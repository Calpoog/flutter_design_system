import 'package:flutter/material.dart';
import 'package:flutter_storybook/storybook.dart';
import 'package:flutter_storybook/ui/panels/tools/tool.dart';
import 'package:flutter_storybook/ui/panels/tools/tool_button.dart';
import 'package:flutter_storybook/ui/utils/text.dart';
import 'package:flutter_storybook/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class ViewportTool extends Tool {
  ViewportTool({Key? key}) : super(key: key, name: 'Change preview size', icon: Icons.aspect_ratio_outlined);

  @override
  bool isActive(BuildContext context) {
    // only need read because of the watch in button method below
    return context.read<ViewportNotifier>().viewportName != null;
  }

  @override
  Widget button(BuildContext context) {
    final theme = context.read<AppTheme>();
    final viewportNotifier = context.watch<ViewportNotifier>();
    final isActive = viewportNotifier.viewportName != null;
    final size = viewportNotifier.size;

    return Row(
      children: [
        CompositedTransformTarget(
          link: link,
          child: ToolButton(
            name: name,
            isActive: isActive,
            text: viewportNotifier.viewportName,
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
                viewportNotifier.setSize(viewportNotifier.viewportName!, Size(size.height, size.width));
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
    final device = context.read<ViewportNotifier>();
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

class ViewportNotifier extends ChangeNotifier {
  String? viewportName;
  double zoom = 1.0;
  Size? size;

  setZoom(double zoom) {
    this.zoom = zoom;
    notifyListeners();
  }

  adjustZoom(double amount) {
    zoom += amount;
    notifyListeners();
  }

  setSize(String name, Size? size) {
    this.size = size;
    viewportName = name;
    notifyListeners();
  }

  resetSize() {
    size = null;
    viewportName = null;
    notifyListeners();
  }
}
