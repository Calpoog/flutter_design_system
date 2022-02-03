import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/models/globals.dart';
import 'package:flutter_design_system/src/storybook.dart';
import 'package:flutter_design_system/src/tools/models/tool.dart';
import 'package:flutter_design_system/src/tools/ui/tool_button.dart';
import 'package:flutter_design_system/src/tools/viewport_tool/viewport_decorator.dart';
import 'package:flutter_design_system/src/ui/utils/text.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class ViewportTool extends Tool {
  ViewportTool({Key? key})
      : super(
          key: key,
          name: 'Change preview size',
          icon: Icons.aspect_ratio_outlined,
          decorator: (_, child, __) => ViewportDecorator(child: child),
        );

  @override
  bool isActive(BuildContext context) {
    // only need read because of the watch in button method below
    return context.read<ViewportProvider>().viewportName != null;
  }

  @override
  Widget button(BuildContext context) {
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
              if (onPressed != null) {
                context.read<OverlayNotifier>().close();
                onPressed!(context);
              } else {
                showToolPopup(context: context, tool: this);
              }
            },
            icon: icon,
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

  @override
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
}

class ViewportProvider extends ChangeNotifier {
  final Globals globals;
  final StorybookConfig config;
  String? viewportName;
  bool landscape = false;
  double zoom = 1.0;

  ViewportProvider({
    required this.globals,
    required this.config,
  });

  Size? get size {
    if (viewportName == null) return null;

    final size = config.deviceSizes[viewportName]!;
    return landscape == true ? Size(size.height, size.width) : size;
  }

  setZoom(double zoom) {
    this.zoom = zoom;
    notifyListeners();
  }

  adjustZoom(double amount) {
    zoom += amount;
    notifyListeners();
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
    notifyListeners();
  }
}
