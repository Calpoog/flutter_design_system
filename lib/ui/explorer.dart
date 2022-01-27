import 'package:flutter/material.dart';
import '../models/story.dart';
import 'utils/text.dart';
import 'utils/theme.dart';
import 'package:provider/provider.dart';

import '../models/component.dart';

class Explorer extends StatelessWidget {
  const Explorer({Key? key, required this.items}) : super(key: key);

  final List<ExplorerItem> items;

  @override
  Widget build(BuildContext context) {
    // Rerender the whole thing rather than subscripe to story changes in each item
    context.watch<StoryNotifier>();
    return SingleChildScrollView(
      child: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(size: 12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: ExplorerHeader(),
            ),
            for (final item in items) item.build(context, 0),
          ],
        ),
      ),
    );
  }
}

class ExplorerHeader extends StatelessWidget {
  const ExplorerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return Column(children: [
      Row(
        children: const [
          FlutterLogo(
            size: 20,
          ),
          SizedBox(width: 7),
          AppText(
            'Flutterbook',
            size: 18,
            weight: FontWeight.w800,
          ),
        ],
      ),
      const SizedBox(height: 20),
      Stack(
        children: [
          Positioned(
            top: 7,
            left: 10,
            child: Icon(
              Icons.search_outlined,
              size: 16,
              color: theme.unselected,
            ),
          ),
          TextFormField(
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(30, 11, 20, 11),
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: theme.unselected.withOpacity(0.4)),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            onChanged: (String value) {},
          ),
        ],
      ),
    ]);
  }
}

enum _ExplorerItemType { root, folder, component, story }

abstract class ExplorerItem {
  final IconData? icon;
  final String name;
  final _ExplorerItemType type;
  final List<ExplorerItem>? children;

  ExplorerItem({
    this.icon,
    required this.name,
    required this.type,
    this.children,
  });

  Widget build(BuildContext context, int depth) => Expandable(item: this, depth: depth);
}

class _StoryItem extends ExplorerItem {
  final Story story;

  _StoryItem({required this.story})
      : super(
          name: story.name,
          type: _ExplorerItemType.story,
        );

  @override
  Widget build(BuildContext context, int depth) {
    return StoryItem(story: story, depth: depth);
  }
}

class StoryItem extends StatelessWidget {
  const StoryItem({
    Key? key,
    required this.story,
    required this.depth,
  }) : super(key: key);

  final Story story;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final storyNotifier = context.read<StoryNotifier>();
    return _ExplorerItem(
      name: story.name,
      icon: Icons.bookmark_outline,
      type: _ExplorerItemType.story,
      onPressed: () => storyNotifier.update(story),
      expandable: false,
      selected: storyNotifier.story == story,
      depth: depth,
    );
  }
}

class Component extends ExplorerItem {
  final ComponentMeta component;

  Component({required this.component})
      : super(
          name: component.name,
          icon: Icons.widgets_outlined,
          type: _ExplorerItemType.component,
          children: component.stories.map((s) => _StoryItem(story: s)).toList(),
        );

  @override
  Widget build(BuildContext context, int depth) {
    if (component.stories.length > 1) {
      return Expandable(item: this, depth: depth);
    } else {
      return StoryItem(story: component.stories.first, depth: depth);
    }
  }
}

class Folder extends ExplorerItem {
  Folder({required String name, List<ExplorerItem>? children})
      : super(
          name: name,
          icon: Icons.folder_outlined,
          type: _ExplorerItemType.folder,
          children: children,
        );
}

class Root extends ExplorerItem {
  Root({required String name, List<ExplorerItem>? children})
      : super(
          name: name,
          type: _ExplorerItemType.root,
          children: children,
        );

  @override
  Widget build(BuildContext context, int depth) {
    assert(depth == 0, 'Root explorer items can only be in the top-level items of a Storybook()');
    return super.build(context, depth);
  }
}

class _ExplorerItem extends StatelessWidget {
  final IconData? icon;
  final _ExplorerItemType type;
  final String name;
  final void Function()? onPressed;
  final bool expandable;
  final bool expanded;
  final bool selected;
  final int depth;

  const _ExplorerItem({
    Key? key,
    required this.name,
    this.icon,
    required this.type,
    this.onPressed,
    required this.depth,
    this.expandable = true,
    this.expanded = false,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    final isRoot = type == _ExplorerItemType.root;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          color: selected ? theme.selected : Colors.transparent,
          padding: EdgeInsets.fromLTRB(
            depth * 17 + 20 - (expandable ? 13 : 0),
            2 + (isRoot ? 10 : 0),
            20,
            2 + (isRoot ? 5 : 0),
          ),
          child: Row(
            children: [
              if (expandable)
                Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: Icon(
                    expanded ? Icons.expand_more : Icons.navigate_next,
                    size: 10,
                    color: theme.unselected,
                  ),
                ),
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    icon,
                    color: selected ? Colors.white : iconColor(theme),
                  ),
                ),
              isRoot
                  ? AppText(
                      name.toUpperCase(),
                      weight: FontWeight.w900,
                      color: theme.unselected,
                      style: const TextStyle(letterSpacing: 3),
                      size: 11,
                    )
                  : AppText(
                      name,
                      size: 13,
                      color: selected ? Colors.white : null,
                    ),
              // TODO: does this expand/collapse all even matter?
              // if (isRoot) const Expanded(child: SizedBox()),
              // if (isRoot)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 5.0),
              //     child: Icon(
              //       Icons.unfold_less,
              //       size: 10,
              //       color: theme.unselected,
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Color iconColor(AppTheme theme) {
    switch (type) {
      case _ExplorerItemType.component:
        return theme.component;
      case _ExplorerItemType.folder:
        return theme.folder;
      case _ExplorerItemType.root:
        return theme.unselected;
      case _ExplorerItemType.story:
        return theme.story;
    }
  }
}

class Expandable extends StatefulWidget {
  const Expandable({
    Key? key,
    required this.item,
    this.expanded = true,
    required this.depth,
  }) : super(key: key);

  final ExplorerItem item;
  final bool expanded;
  final int depth;

  @override
  _ExpandableState createState() => _ExpandableState();
}

class _ExpandableState extends State<Expandable> {
  late bool expanded;

  @override
  void initState() {
    expanded = widget.expanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            debugPrint('clicked');
            setState(() {
              expanded = !expanded;
            });
          },
          child: _ExplorerItem(
            name: widget.item.name,
            icon: widget.item.icon,
            type: widget.item.type,
            depth: widget.depth,
            expanded: expanded,
          ),
        ),
        if (widget.item.children != null)
          SizedBox(
            height: expanded ? null : 0,
            child: Column(
              children: [
                for (final item in widget.item.children!)
                  item.build(
                    context,
                    widget.depth + (widget.item.type == _ExplorerItemType.root ? 0 : 1),
                  )
              ],
            ),
          ),
      ],
    );
  }
}
