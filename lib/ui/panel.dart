import 'package:flutter/material.dart';
import 'package:flutter_storybook/ui/icon_button.dart';
import 'package:flutter_storybook/ui/utils/bordered.dart';

enum ToolAlignment { left, right }

class Tool {
  Tool({required this.name, required this.icon, this.onPressed, this.popup});

  final String name;
  final IconData icon;
  final void Function()? onPressed;
  final Widget? popup;
}

class Panel {
  Panel({required this.name, required this.content, List<Tool>? tools}) : tools = tools ?? [];

  final String name;
  final List<Tool> tools;
  final Widget content;
}

class PanelWidget extends StatelessWidget {
  PanelWidget({
    Key? key,
    required this.panels,
    List<Tool>? tools,
  })  : tools = tools ?? [],
        super(key: key);

  final List<Panel> panels;
  final List<Tool> tools;

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
                      AppIconButton(
                        onPressed: tool.onPressed ?? () {},
                        icon: tool.icon,
                      ),
                    const Expanded(child: SizedBox()),
                    for (final tool in tools)
                      AppIconButton(
                        onPressed: tool.onPressed ?? () {},
                        icon: tool.icon,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: panels.map((panel) => panel.content).toList(),
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
