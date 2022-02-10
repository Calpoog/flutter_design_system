import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/canvas/canvas_panel.dart';
import 'package:flutter_design_system/src/models/documentaton.dart';
import 'package:flutter_design_system/src/models/story.dart';
import 'package:flutter_design_system/src/routing/router_delegate.dart';
import 'package:flutter_design_system/src/ui/panels/panel.dart';
import 'package:flutter_design_system/src/docs/docs_panel.dart';
import 'package:provider/provider.dart';

class ComponentView extends StatefulWidget {
  const ComponentView({Key? key, required this.story}) : super(key: key);

  final Story story;

  @override
  State<ComponentView> createState() => _ComponentViewState();
}

class _ComponentViewState extends State<ComponentView> with TickerProviderStateMixin {
  late final appState = context.read<AppState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDoc = widget.story is Documentation;

    return KeyedSubtree(
      key: ValueKey(widget.story),
      child: PanelGroup(
        initialTab: isDoc || !appState.isViewingDocs ? 0 : 1,
        onTabChange: (int index) => appState.view(index == 1),
        panels: [
          if (!isDoc) CanvasPanel(),
          DocsPanel(),
        ],
      ),
    );
  }
}
