import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

class AppText extends StatelessWidget {
  final String text;
  final FontWeight weight;
  final Color? color;
  final TextStyle? style;
  final double size;

  const AppText(
    this.text, {
    Key? key,
    this.weight = FontWeight.normal,
    this.color,
    this.style,
    this.size = 14,
  }) : super(key: key);
  const AppText.body(String text, {FontWeight weight = FontWeight.normal, Key? key})
      : this(text, weight: weight, key: key);
  const AppText.title(String text, {Key? key}) : this(text, weight: FontWeight.w800, key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'NunitoSans',
        color: color ?? context.read<AppTheme>().body,
        fontWeight: weight,
        fontSize: size,
      ).merge(style),
    );
  }
}

class AppCode extends StatelessWidget {
  final String text;

  const AppCode(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.code,
        border: Border.all(color: theme.border),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
      child: RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: text,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontFamily: 'RobotoMono',
                fontSize: 12,
              ),
        ),
        softWrap: false,
      ),
    );
  }
}

abstract class Heading extends StatelessWidget {
  const Heading({Key? key, required this.text, required this.size, this.useRule = false}) : super(key: key);

  final String text;
  final double size;
  final bool useRule;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.read<AppTheme>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
      margin: EdgeInsets.only(bottom: useRule ? 16 : 8),
      decoration: useRule ? BoxDecoration(border: Border(bottom: BorderSide(color: appTheme.border))) : null,
      child: AppText(
        text,
        size: size,
        weight: FontWeight.w900,
      ),
    );
  }
}

class H1 extends Heading {
  const H1(
    String text, {
    Key? key,
    bool useRule = false,
  }) : super(
          key: key,
          text: text,
          size: 36,
          useRule: useRule,
        );
}

class H2 extends Heading {
  const H2(
    String text, {
    Key? key,
    bool useRule = false,
  }) : super(
          key: key,
          text: text,
          size: 30,
          useRule: useRule,
        );
}

class H3 extends Heading {
  const H3(
    String text, {
    Key? key,
    bool useRule = false,
  }) : super(
          key: key,
          text: text,
          size: 24,
          useRule: useRule,
        );
}

class H4 extends Heading {
  const H4(
    String text, {
    Key? key,
    bool useRule = false,
  }) : super(
          key: key,
          text: text,
          size: 18,
          useRule: useRule,
        );
}

class H5 extends Heading {
  const H5(
    String text, {
    Key? key,
    bool useRule = false,
  }) : super(
          key: key,
          text: text,
          size: 14,
          useRule: useRule,
        );
}

class H6 extends Heading {
  const H6(
    String text, {
    Key? key,
    bool useRule = false,
  }) : super(
          key: key,
          text: text,
          size: 12,
          useRule: useRule,
        );
}
