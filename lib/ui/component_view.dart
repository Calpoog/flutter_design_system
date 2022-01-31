import 'package:flutter/material.dart';
import 'package:flutter_storybook/routing/router_delegate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_storybook/ui/panels/canvas/canvas_panel.dart';
import 'package:flutter_storybook/ui/panels/panel.dart';
import 'package:flutter_storybook/ui/panels/docs_panel.dart';

class ComponentView extends StatelessWidget {
  const ComponentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: context.read<AppState>().args!),
      ],
      child: PanelGroup(panels: [
        CanvasPanel(),
        DocsPanel(),
      ]),
    );
  }
}
