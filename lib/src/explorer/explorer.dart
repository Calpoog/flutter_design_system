import 'package:flutter/material.dart';
import '../models/component.dart';
import '../models/documentation.dart';
import '../models/story.dart';
import '../routing/router_delegate.dart';
import 'explorer_items.dart';
import '../ui/utils/hoverable.dart';
import '../ui/utils/text.dart';
import '../ui/utils/theme.dart';
import 'package:provider/provider.dart';

class Explorer extends StatefulWidget {
  final List<ExplorerItem> items;

  const Explorer({Key? key, required this.items}) : super(key: key);

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  String query = '';
  final List<ExplorerItem> searchable = [];
  late final searchController = TextEditingController();

  @override
  void initState() {
    _processItems(widget.items);
    super.initState();
  }

  // Builds a flat list of Components and Stories for searching
  _processItems(List<ExplorerItem> items) {
    for (int i = 0; i < items.length; i++) {
      ExplorerItem item = items[i];

      if (item is Story || item is Component) searchable.add(item);

      if (item.children != null) {
        _processItems(item.children!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExplorerHeader(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ExplorerSearchField(
            controller: searchController,
            onSearch: (query) {
              setState(() {
                this.query = query;
              });
            },
          ),
        ),
        const SizedBox(height: 20.0),
        Expanded(
          child: query == ''
              ? ExplorerBody(items: widget.items)
              : ExplorerSearchResults(
                  query: query,
                  items: searchable,
                  onSelected: () {
                    setState(() {
                      query = '';
                      searchController.clear();
                    });
                  },
                ),
        ),
      ],
    );
  }
}

class ExplorerHeader extends StatelessWidget {
  const ExplorerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
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
    );
  }
}

class ExplorerSearchField extends StatefulWidget {
  const ExplorerSearchField({
    Key? key,
    required this.onSearch,
    required this.controller,
  }) : super(key: key);

  final void Function(String query) onSearch;
  final TextEditingController controller;

  @override
  State<ExplorerSearchField> createState() => _ExplorerSearchFieldState();
}

class _ExplorerSearchFieldState extends State<ExplorerSearchField> {
  late bool filled;

  @override
  void initState() {
    filled = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  _listener() {
    filled = widget.controller.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return Stack(
      children: [
        Positioned(
          top: 5,
          left: 10,
          child: Icon(
            Icons.search_outlined,
            size: 16,
            color: theme.unselected,
          ),
        ),
        TextFormField(
          style: const TextStyle(fontSize: 13),
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: 'Find components',
            contentPadding: const EdgeInsets.fromLTRB(30, 9, 20, 9),
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: theme.unselected.withOpacity(0.4)),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          onChanged: (String value) {
            setState(() {
              widget.onSearch(value);
            });
          },
        ),
        if (filled)
          Positioned(
            top: 6,
            right: 10,
            child: Hoverable(
              onPressed: () {
                setState(() {
                  widget.controller.clear();
                  widget.onSearch('');
                });
              },
              builder: (context, isHovered) => Icon(
                Icons.cancel,
                size: 16,
                color: isHovered ? theme.selected : theme.unselected,
              ),
            ),
          ),
      ],
    );
  }
}

class ExplorerBody extends StatelessWidget {
  final List<ExplorerItem> items;

  const ExplorerBody({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildItem(context, items[index], 0);
        });
  }

  _buildItem(BuildContext context, ExplorerItem item, int depth) {
    final appState = context.watch<AppState>();
    Widget? child;

    if (item.children != null) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final child in item.children!) _buildItem(context, child, depth + (item.runtimeType == Root ? 0 : 1))
        ],
      );
    }

    switch (item.runtimeType) {
      case Root:
        return RootWidget(item: item as Root, depth: depth, child: child);
      case Folder:
        return FolderWidget(item: item as Folder, depth: depth, child: child);
      case Documentation:
        return DocumentationItemWidget(
            item: item as Documentation,
            depth: depth,
            isSelected: appState.story == item,
            onPressed: () {
              appState.setStory(item as Story);
            });
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

class ExplorerSearchResults extends StatelessWidget {
  final List<ExplorerItem> items;
  late final List<ExplorerItem> results;
  final String query;
  final VoidCallback onSelected;

  ExplorerSearchResults({
    Key? key,
    required this.items,
    required this.query,
    required this.onSelected,
  }) : super(key: key) {
    results = items.where((item) => item.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final theme = context.read<AppTheme>();
          final result = results[index];
          final path = result.path.split('/');
          return Hoverable(
            onPressed: () {
              context
                  .read<AppState>()
                  .setStory((result is Story ? result : (result as Component).children!.first) as Story);
              onSelected();
            },
            builder: (context, isHovered) {
              return Container(
                color: isHovered ? theme.selected.withOpacity(0.1) : null,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          result is Story ? Icons.bookmark_outline : Icons.widgets_outlined,
                          color: result is Story ? theme.story : theme.component,
                          size: 12,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: AppText(
                              result.name,
                              size: 13,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 17),
                      child: AppText(
                        path.sublist(1, path.length - 1).join('/'),
                        size: 12,
                        color: theme.unselected,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
