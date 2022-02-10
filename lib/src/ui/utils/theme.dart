import 'package:flutter/widgets.dart';

class AppTheme {
  final Color unselected;
  final Color foreground;
  final Color selected;
  final Color body;
  final Color background;
  final Color backgroundDark;
  final Color border;
  final Color code;
  final Color story;
  final Color component;
  final Color folder;
  final Color inputBorder;
  final Color docs;

  AppTheme({
    this.background = const Color.fromRGBO(246, 249, 252, 1),
    this.backgroundDark = const Color.fromRGBO(127, 127, 127, 1),
    this.foreground = const Color.fromRGBO(255, 255, 255, 1),
    this.selected = const Color.fromRGBO(30, 167, 253, 1),
    this.unselected = const Color.fromRGBO(153, 153, 153, 1),
    this.body = const Color.fromRGBO(55, 55, 55, 1),
    this.border = const Color.fromRGBO(0, 0, 0, 0.1),
    this.inputBorder = const Color.fromRGBO(0, 0, 0, 0.2),
    this.code = const Color.fromRGBO(248, 248, 248, 1),
    this.story = const Color.fromRGBO(55, 213, 211, 1),
    this.component = const Color.fromRGBO(30, 167, 253, 1),
    this.folder = const Color.fromRGBO(42, 4, 129, 1),
    this.docs = const Color.fromRGBO(255, 131, 0, 1),
  });
}
