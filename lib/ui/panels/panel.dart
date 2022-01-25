import 'package:flutter/material.dart';
import 'package:flutter_storybook/ui/icon_button.dart';
import 'package:flutter_storybook/ui/utils/bordered.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

enum ToolAlignment { left, right }

class Tool {
  Tool({required this.name, required this.icon, this.onPressed, this.popup}) : _link = LayerLink();

  final String name;
  final IconData icon;
  final void Function(BuildContext context)? onPressed;
  final Widget Function(BuildContext context, void Function() close)? popup;
  final LayerLink _link;
}

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

class PanelGroup extends StatefulWidget {
  PanelGroup({
    Key? key,
    required this.panels,
    List<Tool>? tools,
  })  : tools = tools ?? [],
        super(key: key);

  final List<Panel> panels;
  final List<Tool> tools;

  @override
  State<PanelGroup> createState() => _PanelGroupState();
}

class _PanelGroupState extends State<PanelGroup> {
  OverlayEntry? overlayEntry;
  double popupWidth = 200;

  void showToolPopup(BuildContext panelContext, Tool tool) {
    if (overlayEntry != null) overlayEntry!.remove();

    final link = tool._link;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        final theme = context.read<AppTheme>();
        return Positioned(
          top: 0.0,
          left: 0.0,
          child: CompositedTransformFollower(
            followerAnchor: Alignment.topCenter,
            targetAnchor: Alignment.bottomCenter,
            link: link,
            child: Material(
              child: Container(
                width: popupWidth,
                constraints: BoxConstraints.loose(Size(popupWidth, 300)),
                decoration: BoxDecoration(
                  color: theme.foreground,
                  border: Border.all(color: theme.border),
                  boxShadow: const [
                    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 5, offset: Offset(0, 5))
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: tool.popup!(panelContext, closePopup),
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context)!.insert(overlayEntry!);
  }

  void closePopup() {
    overlayEntry!.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.panels.length,
      child: Builder(
        builder: (context) {
          Panel currentPanel = widget.panels[DefaultTabController.of(context)!.index];
          return Column(
            children: [
              Bordered.bottom(
                child: Row(
                  children: [
                    TabBar(
                      isScrollable: true,
                      tabs: [
                        for (final panel in widget.panels) Tab(text: panel.name),
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
                        link: tool._link,
                        child: AppIconButton(
                          onPressed: () {
                            if (tool.onPressed != null) {
                              tool.onPressed!(context);
                            } else if (tool.popup != null) {
                              showToolPopup(context, tool);
                            }
                          },
                          icon: tool.icon,
                        ),
                      ),
                    const Expanded(child: SizedBox()),
                    for (final tool in widget.tools)
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
                  children: widget.panels,
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
