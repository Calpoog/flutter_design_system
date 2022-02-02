import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/models/component.dart';
import 'package:flutter_design_system/src/storybook.dart';
import 'package:flutter_design_system/src/tools/ui/tool_button.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class Tool {
  Tool({
    Key? key,
    required this.name,
    required this.icon,
    this.onPressed,
    this.divide = false,
    this.decorator,
  }) : link = LayerLink();

  final String name;
  final IconData icon;
  final bool divide;

  /// A callback for when the tool button is clicked.
  ///
  /// If [onPressed] is specified then the tool cannot have a [popup].
  final void Function(BuildContext context)? onPressed;
  final LayerLink link;
  final Decorator? decorator;

  bool isActive(BuildContext context) => false;

  Widget popup(BuildContext context) => const SizedBox();

  Widget button(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: ToolButton(
        name: name,
        isActive: isActive(context),
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
    );
  }
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
                child: tool.popup(context),
              ),
            ),
          ),
        ),
      );
    },
  );
  overlay.add(context, entry);
}
