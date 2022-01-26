import 'package:flutter/material.dart';
import 'package:flutter_storybook/storybook.dart';
import 'package:flutter_storybook/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class Tool {
  Tool({required this.name, required this.icon, this.onPressed, this.popup}) : link = LayerLink();

  final String name;
  final IconData icon;
  final void Function(BuildContext context)? onPressed;
  final WidgetBuilder? popup;
  final LayerLink link;
}

const double _kPopupWidth = 200.0;
const double _kPopupMaxHeight = 300.0;

void showToolPopup({required BuildContext context, required Tool tool}) {
  final overlay = context.read<OverlayNotifier>();
  final link = tool.link;
  final entry = OverlayEntry(
    builder: (BuildContext overlayContext) {
      final theme = context.read<AppTheme>();
      return Positioned(
        top: 0.0,
        left: 0.0,
        child: CompositedTransformFollower(
          followerAnchor: Alignment.topCenter,
          targetAnchor: Alignment.bottomCenter,
          offset: const Offset(0, 12),
          link: link,
          child: Container(
            clipBehavior: Clip.hardEdge,
            width: _kPopupWidth,
            constraints: BoxConstraints.loose(const Size(_kPopupWidth, _kPopupMaxHeight)),
            decoration: BoxDecoration(
              border: Border.all(color: theme.border),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 5,
                  blurStyle: BlurStyle.outer,
                )
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Material(
                color: theme.foreground,
                child: tool.popup!(context),
              ),
            ),
          ),
        ),
      );
    },
  );
  overlay.add(context, entry);
}
