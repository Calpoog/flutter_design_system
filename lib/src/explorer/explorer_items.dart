import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/models/component.dart';
import 'package:flutter_design_system/src/models/story.dart';
import 'package:flutter_design_system/src/ui/utils/hoverable.dart';
import 'package:flutter_design_system/src/ui/utils/text.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:provider/provider.dart';

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
  final VoidCallback onPressed;
  final bool isSelected;

  const StoryItemWidget({
    Key? key,
    required this.item,
    required this.depth,
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
                      child: Icon(
                        widget.icon!,
                        color: widget.isSelected ? Colors.white : widget.iconColor,
                        size: 12,
                      ),
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
