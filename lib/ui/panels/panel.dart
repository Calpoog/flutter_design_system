import 'package:flutter/material.dart';
import 'package:flutter_storybook/ui/panels/tools/divider.dart';
import 'package:flutter_storybook/ui/panels/tools/tool.dart';
import 'package:flutter_storybook/ui/utils/bordered.dart';

abstract class Panel extends StatelessWidget {
  Panel({
    required this.name,
    List<Tool>? tools,
    Key? key,
  })  : tools = tools ?? [],
        super(key: key);

  final String name;
  final List<Tool> tools;
}

class PanelGroup extends StatelessWidget {
  PanelGroup({
    Key? key,
    required this.panels,
    List<Tool>? tools,
  })  : tools = tools ?? [],
        super(key: key);

  final List<Panel> panels;
  final List<Tool> tools;
  final double popupWidth = 200;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: panels.length,
      child: Builder(
        builder: (context) {
          Panel currentPanel = panels[DefaultTabController.of(context)!.index];
          return Column(
            children: [
              Bordered.bottom(
                child: SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      TabBar(
                        isScrollable: true,
                        tabs: [
                          for (final panel in panels)
                            Tab(
                              text: panel.name,
                              height: 40,
                            ),
                        ],
                      ),
                      if (currentPanel.tools.isNotEmpty) const ToolDivider(),
                      for (final tool in currentPanel.tools) ...[
                        tool.button(context),
                        if (tool.divide) const ToolDivider(),
                      ],
                      const Expanded(child: SizedBox()),
                      for (final tool in tools) tool.button(context),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: panels,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
