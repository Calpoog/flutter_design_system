import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      style: GoogleFonts.nunitoSans(
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
        text: TextSpan(text: text, style: GoogleFonts.robotoMono(fontSize: 12)),
        softWrap: false,
      ),
    );
  }
}
