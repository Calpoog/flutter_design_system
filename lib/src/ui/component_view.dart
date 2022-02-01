import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/canvas/canvas_panel.dart';
import 'package:flutter_design_system/src/ui/panels/panel.dart';
import 'package:flutter_design_system/src/docs/docs_panel.dart';

class ComponentView extends StatelessWidget {
  const ComponentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PanelGroup(panels: [
      CanvasPanel(),
      DocsPanel(),
    ]);
  }
}
