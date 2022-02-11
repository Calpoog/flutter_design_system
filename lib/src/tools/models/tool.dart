import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/models/globals.dart';
import 'package:flutter_design_system/src/design_system.dart';
import 'package:flutter_design_system/src/tools/ui/tool_button.dart';
import 'package:flutter_design_system/src/ui/utils/text.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:provider/provider.dart';

/// A list item for simple tools which displays as an option in the tool popup
/// and save values to globals.
class ToolItem<T> {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final T value;

  const ToolItem({
    required this.title,
    this.leading,
    this.trailing,
    required this.value,
    Key? key,
  });
}

class Tool extends StatefulWidget {
  const Tool({
    Key? key,
    this.buttonBuilder,
    this.popupBuilder,
    required this.name,
    this.isActive = false,
    this.options,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  /// A builder to create a custom button if the default [ToolButton] does not suffice.
  final Widget Function(BuildContext context, LayerLink link)? buttonBuilder;

  /// A builder for a custom popup.
  ///
  /// The popup will not use [options]. If [onPressed] is provided it will take
  /// precedence and be called on button click.
  final WidgetBuilder? popupBuilder;

  /// The name of the tool to display as a tooltip.
  final String name;

  /// An icon to display for the tool's button.
  final IconData icon;

  /// Whether the tool button should display an active indicator.
  final bool isActive;

  /// A list of [ToolItem] which will show in a popup when the tool button is
  /// clicked. The selected item will have its value persisted to globals.
  ///
  /// If [options] is specified then the tool cannot have an [onPressed] callback.
  final List<ToolItem>? options;

  /// A callback for when the tool button is clicked.
  ///
  /// If [onPressed] is specified then the tool cannot have [options].
  final VoidCallback? onPressed;

  @override
  _ToolState createState() => _ToolState();
}

class _ToolState extends State<Tool> {
  late final link = LayerLink();
  late final OverlayNotifier overlay;

  @override
  void initState() {
    overlay = context.read<OverlayNotifier>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.buttonBuilder == null ? _buttonBuilder(context, link) : widget.buttonBuilder!(context, link);
  }

  Widget _buttonBuilder(BuildContext context, _) {
    return CompositedTransformTarget(
      link: link,
      child: ToolButton(
        name: widget.name,
        isActive: widget.isActive,
        onPressed: () {
          if (widget.onPressed != null) {
            context.read<OverlayNotifier>().close();
            widget.onPressed!();
          } else {
            showToolPopup(
                context: context,
                link: link,
                child: widget.popupBuilder == null ? _popupBuilder(context) : widget.popupBuilder!(context));
          }
        },
        icon: widget.icon,
      ),
    );
  }

  Widget _popupBuilder(BuildContext context) {
    if (widget.options == null) return const SizedBox();

    final theme = context.read<AppTheme>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widget.options!
          .map(
            (option) => ListTile(
              title: AppText.body(option.title),
              hoverColor: theme.background,
              leading: option.trailing,
              trailing: option.trailing,
              onTap: () {
                context.read<Globals>()[widget.name] = option.value;
                overlay.close();
              },
            ),
          )
          .toList(),
    );
  }

  @override
  void dispose() {
    overlay.close();
    super.dispose();
  }
}

const double _kPopupWidth = 200.0;
const double _kPopupMaxHeight = 300.0;

void showToolPopup({required BuildContext context, required LayerLink link, required Widget child}) {
  final overlay = context.read<OverlayNotifier>();
  final entry = OverlayEntry(
    builder: (BuildContext overlayContext) {
      final theme = context.read<AppTheme>();
      return Positioned(
        top: 0.0,
        left: 0.0,
        child: CompositedTransformFollower(
          showWhenUnlinked: false,
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
                child: child,
              ),
            ),
          ),
        ),
      );
    },
  );
  overlay.add(context, entry);
}
