import 'package:flutter/material.dart';

class Hoverable extends StatefulWidget {
  final Widget Function(BuildContext context, bool isHovered) builder;

  const Hoverable({Key? key, required this.builder}) : super(key: key);

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  late bool isHovered;

  @override
  void initState() {
    isHovered = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() => isHovered = true),
      onExit: (event) => setState(() => isHovered = false),
      child: widget.builder(context, isHovered),
    );
  }
}
