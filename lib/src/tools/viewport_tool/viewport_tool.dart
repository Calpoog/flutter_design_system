import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/models/globals.dart';
import 'package:flutter_design_system/src/storybook.dart';
import 'package:flutter_design_system/src/tools/models/tool.dart';
import 'package:flutter_design_system/src/tools/ui/tool_button.dart';
import 'package:flutter_design_system/src/tools/viewport_tool/viewport_decorator.dart';
import 'package:flutter_design_system/src/ui/utils/text.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class ViewportTool extends StatelessWidget {
  const ViewportTool({Key? key}) : super(key: key);

  final name = 'Change preview size';

  static Widget decorator(BuildContext context, Widget child, Globals globals) {
    return ViewportDecorator(child: child);
  }

  // @override
  // bool isActive(BuildContext context) {
  //   // only need read because of the watch in button method below
  //   return context.read<ViewportProvider>().viewportName != null;
  // }

  Widget button(BuildContext context, LayerLink link) {
    final theme = context.read<AppTheme>();
    final viewportProvider = context.watch<ViewportProvider>();
    final isActive = viewportProvider.viewportName != null;
    final size = viewportProvider.size;

    return Row(
      children: [
        CompositedTransformTarget(
          link: link,
          child: ToolButton(
            name: name,
            isActive: isActive,
            text: viewportProvider.viewportName,
            onPressed: () {
              showToolPopup(context: context, link: link, child: popup(context));
            },
            icon: Icons.aspect_ratio_outlined,
          ),
        ),
        if (isActive) ...[
          const SizedBox(width: 5.0),
          AppText(
            size!.width.toString(),
            weight: FontWeight.bold,
            color: theme.unselected,
          ),
          ToolButton(
              name: 'Change orientation',
              icon: Icons.sync_alt_outlined,
              onPressed: () {
                viewportProvider.flip();
              }),
          AppText(
            size.height.toString(),
            weight: FontWeight.bold,
            color: theme.unselected,
          ),
        ]
      ],
    );
  }

  Widget popup(BuildContext context) {
    final device = context.read<ViewportProvider>();
    final overlay = context.read<OverlayNotifier>();
    final hoverColor = context.read<AppTheme>().background;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: const AppText.body('Reset viewport'),
          hoverColor: hoverColor,
          onTap: () {
            device.resetSize();
            overlay.close();
          },
        ),
        ...context
            .read<StorybookConfig>()
            .deviceSizes
            .entries
            .map(
              (entry) => ListTile(
                title: AppText.body(entry.key),
                hoverColor: hoverColor,
                onTap: () {
                  device.setSize(entry.key, entry.value);
                  overlay.close();
                },
              ),
            )
            .toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tool(
      name: name,
      icon: Icons.aspect_ratio_outlined,
      buttonBuilder: button,
      popupBuilder: popup,
      isActive: context.read<ViewportProvider>().viewportName != null,
    );
  }
}

class ViewportProvider extends ChangeNotifier {
  final Globals globals;
  final StorybookConfig config;
  String? viewportName;
  bool landscape = false;

  ViewportProvider({
    required this.globals,
    required this.config,
  }) {
    viewportName = globals['viewport.name'];
    if (globals['viewport.landscape'] != null) landscape = true;
  }

  Size? get size {
    if (viewportName == null) return null;

    final size = config.deviceSizes[viewportName]!;
    return landscape == true ? Size(size.height, size.width) : size;
  }

  setSize(String name, Size? size) {
    viewportName = name;
    globals['viewport.name'] = name;
    notifyListeners();
  }

  flip() {
    landscape = !landscape;
    if (landscape) {
      globals['viewport.landscape'] = 'true';
    } else {
      globals.remove('viewport.landscape');
    }
    notifyListeners();
  }

  resetSize() {
    viewportName = null;
    globals.remove('viewport.name');
    globals.remove('viewport.landscape');
    notifyListeners();
  }
}
