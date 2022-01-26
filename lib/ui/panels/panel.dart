import 'package:flutter/material.dart';
import 'package:flutter_storybook/storybook.dart';
import 'package:flutter_storybook/ui/panels/tools/tool.dart';
import 'package:flutter_storybook/ui/utils/icon_button.dart';
import 'package:flutter_storybook/ui/utils/bordered.dart';
import 'package:provider/provider.dart';

import '../utils/theme.dart';

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
                child: Row(
                  children: [
                    TabBar(
                      isScrollable: true,
                      tabs: [
                        for (final panel in panels) Tab(text: panel.name),
                      ],
                    ),
                    if (currentPanel.tools.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Bordered.right(
                          child: SizedBox(
                            height: 25,
                          ),
                        ),
                      ),
                    // Expanded(child: const SizedBox()),
                    for (final tool in currentPanel.tools)
                      CompositedTransformTarget(
                        link: tool.link,
                        child: AppIconButton(
                          onPressed: () {
                            if (tool.onPressed != null) {
                              tool.onPressed!(context);
                            } else if (tool.popup != null) {
                              showToolPopup(context: context, tool: tool);
                            }
                          },
                          icon: tool.icon,
                        ),
                      ),
                    const Expanded(child: SizedBox()),
                    for (final tool in tools)
                      AppIconButton(
                        onPressed: () {
                          if (tool.onPressed != null) tool.onPressed!(context);
                        },
                        icon: tool.icon,
                      ),
                  ],
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
