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

  AppTheme({
    this.background = const Color.fromRGBO(246, 249, 252, 1),
    this.backgroundDark = const Color.fromRGBO(127, 127, 127, 1),
    this.foreground = const Color.fromRGBO(255, 255, 255, 1),
    this.selected = const Color.fromRGBO(30, 167, 253, 1),
    this.unselected = const Color.fromRGBO(153, 153, 153, 1),
    this.body = const Color.fromRGBO(55, 55, 55, 1),
    this.border = const Color.fromRGBO(229, 229, 229, 1),
    this.code = const Color.fromRGBO(248, 248, 248, 1),
    this.story = const Color.fromRGBO(55, 213, 211, 1),
    this.component = const Color.fromRGBO(30, 167, 253, 1),
    this.folder = const Color.fromRGBO(189, 30, 253, 1),
  });
}
