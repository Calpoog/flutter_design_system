import 'package:flutter/material.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:flutter_storybook/models/component.dart';
import 'package:flutter_storybook/models/story.dart';
import 'package:flutter_storybook/routing/router_delegate.dart';
import 'package:flutter_storybook/ui/utils/hoverable.dart';
import 'package:flutter_storybook/ui/utils/text.dart';
import 'package:flutter_storybook/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class Explorer extends StatelessWidget {
  final List<ExplorerItem> items;

  const Explorer({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: const IconThemeData(size: 12),
      ),
      child: ListView.builder(
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const ExplorerHeader();
            }
            return _buildItem(context, items[index - 1], 0);
          }),
    );
  }

  _buildItem(BuildContext context, ExplorerItem item, int depth) {
    final appState = context.watch<AppState>();
    Widget? child;

    if (item.children != null) {
      child = Column(
        children: [
          for (final child in item.children!) _buildItem(context, child, depth + (item.runtimeType == RootItem ? 0 : 1))
        ],
      );
    }

    switch (item.runtimeType) {
      case RootItem:
        return RootItemWidget(item: item as RootItem, depth: depth, child: child);
      case FolderItem:
        return FolderItemWidget(item: item as FolderItem, depth: depth, child: child);
      case Component:
        if (item.children!.length == 1 && item.children!.first.name == item.name) {
          // Let the single story of same-name through
          item = item.children!.first;
        } else {
          return ComponentItemWidget(item: item as Component, depth: depth, child: child);
        }
    }

    return StoryItemWidget(
      item: item as Story,
      depth: depth,
      isSelected: appState.story == item,
      onPressed: () {
        appState.setStory(item as Story);
      },
    );
  }
}

abstract class ExplorerItem {
  final String name;
  List<ExplorerItem>? children;
  bool isExpanded;
  late String path;

  ExplorerItem({
    required this.name,
    this.children,
    bool? isExpanded,
  }) : isExpanded = isExpanded ?? true;
}

class RootItem extends ExplorerItem {
  RootItem({
    required String name,
    required List<ExplorerItem> children,
    bool? isExpanded,
  }) : super(
          name: name,
          children: children,
          isExpanded: isExpanded,
        );
}

class RootItemWidget extends StatelessWidget {
  final RootItem item;
  final int depth;
  final Widget? child;

  const RootItemWidget({Key? key, required this.item, required this.depth, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Item(
      name: item.name,
      depth: depth,
      child: child,
      isExpanded: item.isExpanded,
      text: AppText(
        item.name.toUpperCase(),
        weight: FontWeight.w900,
        color: context.read<AppTheme>().unselected,
        style: const TextStyle(letterSpacing: 3),
        size: 11,
      ),
    );
  }
}

class FolderItem extends ExplorerItem {
  FolderItem({
    required String name,
    required List<ExplorerItem> children,
    bool? isExpanded,
  }) : super(
          name: name,
          children: children,
          isExpanded: isExpanded,
        );
}

class FolderItemWidget extends StatelessWidget {
  final FolderItem item;
  final int depth;
  final Widget? child;

  const FolderItemWidget({Key? key, required this.item, required this.depth, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Item(
      name: item.name,
      depth: depth,
      child: child,
      icon: Icons.folder_outlined,
      iconColor: context.read<AppTheme>().folder,
      isExpanded: item.isExpanded,
    );
  }
}

class ComponentItemWidget extends StatelessWidget {
  final Component item;
  final int depth;
  final Widget? child;

  const ComponentItemWidget({Key? key, required this.item, required this.depth, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Item(
      name: item.name,
      depth: depth,
      child: child,
      icon: Icons.widgets_outlined,
      iconColor: context.read<AppTheme>().component,
      isExpanded: item.isExpanded,
    );
  }
}

class StoryItemWidget extends StatelessWidget {
  final Story item;
  final int depth;
  final Widget? child;
  final VoidCallback onPressed;
  final bool isSelected;

  const StoryItemWidget({
    Key? key,
    required this.item,
    required this.depth,
    this.child,
    required this.onPressed,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Item(
      name: item.name,
      depth: depth,
      icon: Icons.bookmark_outline,
      iconColor: context.read<AppTheme>().story,
      isExpandable: false,
      isSelected: isSelected,
      onPressed: onPressed,
    );
  }
}

class _Item extends StatefulWidget {
  const _Item({
    Key? key,
    this.name,
    this.text,
    this.icon,
    this.iconColor = Colors.black,
    this.isSelected = false,
    this.isExpandable = true,
    this.isExpanded = false,
    required this.depth,
    this.onPressed,
    this.child,
    this.margin,
  })  : assert(name != null || text != null),
        super(key: key);

  final String? name;
  final Widget? text;
  final IconData? icon;
  final Color iconColor;
  final bool isSelected;
  final bool isExpandable;
  final bool isExpanded;
  final int depth;
  final VoidCallback? onPressed;
  final Widget? child;
  final EdgeInsets? margin;

  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> {
  late bool isExpanded;
  VoidCallback? onPressed;

  @override
  void initState() {
    isExpanded = widget.isExpanded;
    onPressed = widget.onPressed;
    if (widget.isExpandable) {
      onPressed = () {
        setState(() => isExpanded = !isExpanded);
      };
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return Column(
      children: [
        Hoverable(
          onPressed: onPressed,
          builder: (context, isHovered) {
            return Container(
              color: widget.isSelected
                  ? theme.selected
                  : isHovered
                      ? theme.selected.withOpacity(0.1)
                      : null,
              padding: EdgeInsets.fromLTRB(widget.depth * 17 + 7, 2, 20, 2),
              margin: widget.margin,
              child: Row(
                children: [
                  if (widget.isExpandable)
                    Icon(
                      isExpanded ? Icons.expand_more : Icons.navigate_next,
                      size: 10,
                      color: theme.unselected,
                    ),
                  if (widget.icon != null)
                    Padding(
                      padding: EdgeInsets.only(left: widget.isExpandable ? 3.0 : 13.0),
                      child: Icon(widget.icon!, color: widget.isSelected ? Colors.white : widget.iconColor),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: widget.text ??
                        AppText(
                          widget.name!,
                          size: 13,
                          color: widget.isSelected ? Colors.white : null,
                        ),
                  ),
                ],
              ),
            );
          },
        ),
        if (widget.child != null && isExpanded) widget.child!,
      ],
    );
  }
}

class ExplorerHeader extends StatelessWidget {
  const ExplorerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
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
                hintText: 'Find components',
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
      ]),
    );
  }
}
