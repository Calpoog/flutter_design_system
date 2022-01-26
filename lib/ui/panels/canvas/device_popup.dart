import 'package:flutter/material.dart';
import 'package:flutter_storybook/storybook.dart';
import 'package:flutter_storybook/ui/panels/canvas/canvas_panel.dart';
import 'package:flutter_storybook/ui/utils/text.dart';
import 'package:flutter_storybook/ui/utils/theme.dart';
import 'package:provider/provider.dart';

Widget backgroundPopup(BuildContext context) {
  final overlay = context.read<OverlayNotifier>();
  final theme = context.read<AppTheme>();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: context
        .read<StorybookConfig>()
        .backgrounds
        .entries
        .map(
          (entry) => ListTile(
            title: AppText.body(entry.key),
            hoverColor: theme.background,
            trailing: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: entry.value,
                border: Border.all(color: theme.backgroundDark),
              ),
            ),
            onTap: () {
              context.read<BackgroundNotifier>().update(entry.value);
              overlay.close();
            },
          ),
        )
        .toList(),
  );
}
