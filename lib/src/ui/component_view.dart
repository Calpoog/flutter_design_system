import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/canvas/canvas_panel.dart';
import 'package:flutter_design_system/src/models/story.dart';
import 'package:flutter_design_system/src/routing/router_delegate.dart';
import 'package:flutter_design_system/src/ui/panels/panel.dart';
import 'package:flutter_design_system/src/docs/docs_panel.dart';
import 'package:provider/provider.dart';

class ComponentView extends StatefulWidget {
  const ComponentView({Key? key}) : super(key: key);

  @override
  State<ComponentView> createState() => _ComponentViewState();
}

class _ComponentViewState extends State<ComponentView> with SingleTickerProviderStateMixin {
  late final appState = context.read<AppState>();
  late final controller = TabController(length: 2, vsync: this, initialIndex: appState.isViewingDocs ? 1 : 0);

  @override
  void initState() {
    appState.addListener(_stateListener);
    controller.addListener(_tabListener);
    super.initState();
  }

  _stateListener() {
    controller.animateTo(appState.isViewingDocs ? 1 : 0);
  }

  _tabListener() {
    appState.view(controller.index == 1);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<Story>();
    return PanelGroup(
      controller: controller,
      panels: [
        CanvasPanel(),
        DocsPanel(),
      ],
    );
  }

  @override
  void dispose() {
    appState.removeListener(_stateListener);
    controller.removeListener(_tabListener);
    super.dispose();
  }
}
