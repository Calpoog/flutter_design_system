import 'package:flutter/material.dart';
import '../../routing/router_delegate.dart';
import '../../tools/ui/divider.dart';
import '../../tools/models/tool.dart';
import '../toolbar.dart';
import '../utils/bordered.dart';
import 'package:provider/provider.dart';

abstract class Panel extends StatelessWidget {
  const Panel({
    required this.name,
    Key? key,
  }) : super(key: key);

  final String name;

  List<Widget> toolsBuilder(BuildContext context) => [];
}

class PanelGroup extends StatefulWidget {
  PanelGroup({
    Key? key,
    required this.panels,
    List<Tool>? tools,
    this.onTabChange,
    this.initialTab = 0,
  })  : tools = tools ?? [],
        super(key: key);

  final List<Panel> panels;
  final List<Tool> tools;
  final void Function(int index)? onTabChange;
  final int initialTab;

  @override
  State<PanelGroup> createState() => _PanelGroupState();
}

class _PanelGroupState extends State<PanelGroup> with SingleTickerProviderStateMixin {
  final double popupWidth = 200;
  late TabController controller;
  late final appState = context.read<AppState>();
  Panel get currentPanel => widget.panels[controller.index];

  @override
  void initState() {
    controller = TabController(initialIndex: widget.initialTab, length: widget.panels.length, vsync: this);
    controller.addListener(_tabListener);
    super.initState();
  }

  _tabListener() {
    if (widget.onTabChange != null) widget.onTabChange!(controller.index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tools = currentPanel.toolsBuilder(context);
    return Column(
      children: [
        Bordered.bottom(
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                TabBar(
                  isScrollable: true,
                  controller: controller,
                  tabs: [
                    for (final panel in widget.panels)
                      Tab(
                        text: panel.name,
                        height: 40,
                      ),
                  ],
                ),
                if (tools.isNotEmpty) const ToolDivider(),
                Toolbar(tools: tools),
                const Expanded(child: SizedBox()),
                ...widget.tools,
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: widget.panels,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.removeListener(_tabListener);
    controller.dispose();
    super.dispose();
  }
}
