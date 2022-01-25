import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

class Bordered extends StatelessWidget {
  final Widget? child;
  final bool top;
  final bool left;
  final bool bottom;
  final bool right;

  // const SingleBorder({Key? key, this.child}) : super(key: key);
  const Bordered({
    Key? key,
    this.child,
    this.top = false,
    this.left = false,
    this.bottom = false,
    this.right = false,
  }) : super(key: key);

  const Bordered.top({Key? key, Widget? child}) : this(key: key, child: child, top: true);
  const Bordered.right({Key? key, Widget? child}) : this(key: key, child: child, right: true);
  const Bordered.bottom({Key? key, Widget? child}) : this(key: key, child: child, bottom: true);
  const Bordered.left({Key? key, Widget? child}) : this(key: key, child: child, left: true);

  @override
  Widget build(BuildContext context) {
    final side = BorderSide(
      color: context.read<AppTheme>().border,
    );
    const none = BorderSide.none;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: top ? side : none,
          right: right ? side : none,
          bottom: bottom ? side : none,
          left: left ? side : none,
        ),
      ),
      child: child ?? const SizedBox(),
    );
  }
}
