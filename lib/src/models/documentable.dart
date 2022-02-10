import 'package:flutter/material.dart';

abstract class Documentable {
  final String? markdownFile;
  final String? markdownString;
  final Widget? docWidget;

  Documentable({this.markdownFile, this.markdownString, this.docWidget});
}
