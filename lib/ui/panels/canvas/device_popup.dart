import 'package:flutter/material.dart';
import 'package:flutter_storybook/storybook.dart';
import 'package:flutter_storybook/ui/panels/canvas/canvas_panel.dart';
import 'package:flutter_storybook/ui/panels/tools/tool.dart';
import 'package:flutter_storybook/ui/utils/text.dart';
import 'package:flutter_storybook/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class DevicesTool extends Tool {
  DevicesTool({Key? key}) : super(key: key, name: 'devices', icon: Icons.aspect_ratio_outlined);

  @override
  Widget popup(BuildContext context) {
    final device = context.read<DeviceNotifier>();
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
            device.setSize(null);
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
                  device.setSize(entry.value);
                  overlay.close();
                },
              ),
            )
            .toList(),
      ],
    );
  }
}

class DeviceNotifier extends ChangeNotifier {
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

  setSize(Size? size) {
    this.size = size;
    notifyListeners();
  }
}
