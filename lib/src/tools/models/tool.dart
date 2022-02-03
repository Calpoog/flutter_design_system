import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/models/component.dart';
import 'package:flutter_design_system/src/models/globals.dart';
import 'package:flutter_design_system/src/storybook.dart';
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

class ToolItemWidget<T> extends StatelessWidget {
  final ToolItem<T> item;
  final void Function(T value) onPressed;

  const ToolItemWidget({
    required this.item,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return ListTile(
      title: AppText.body(item.title),
      hoverColor: theme.background,
      leading: item.leading,
      trailing: item.trailing,
      onTap: () => onPressed(item.value),
    );
  }
}

class Tool<T> {
  Tool({
    Key? key,
    required this.name,
    required this.icon,
    this.onPressed,
    this.divide = false,
    this.decorator,
    this.options,
    this.serialize,
  })  : assert(onPressed == null || options == null, 'A tool cannot have an onPressed callback and options'),
        link = LayerLink();

  final String name;
  final IconData icon;
  final bool divide;

  /// A list of [ToolItem] which will show in a popup when the tool button is
  /// clicked. The selected item will have its value persisted to globals.
  ///
  /// If [options] is specified then the tool cannot have an [onPressed] callback.
  final List<ToolItem>? options;

  /// A function to serialize the values of type [T] to [String] when a tool
  /// option is selected and saved to globals.
  late final String Function(T value)? serialize;
  late final T Function(String value)? deserialize;

  /// A callback for when the tool button is clicked.
  ///
  /// If [onPressed] is specified then the tool cannot have [options].
  final void Function(BuildContext context)? onPressed;
  final LayerLink link;
  final Decorator? decorator;

  bool isActive(BuildContext context) => false;

  Widget popup(BuildContext context) {
    if (options == null) return const SizedBox();

    final overlay = context.read<OverlayNotifier>();
    final theme = context.read<AppTheme>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: options!
          .map(
            (option) => ListTile(
              title: AppText.body(option.title),
              hoverColor: theme.background,
              leading: option.trailing,
              trailing: option.trailing,
              onTap: () {
                context.read<Globals>().updateValue(name, option.value);
                overlay.close();
              },
            ),
          )
          .toList(),
    );
  }

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
