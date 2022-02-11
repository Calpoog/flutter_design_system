import 'package:flutter/material.dart';

/// A base for models that can have documentation in form of a markdown file,
/// string, or [Widget].
abstract class Documentable {
  /// A string path to a markdown file which must be accessible in the pubspec
  /// assets.
  final String? markdownFile;

  /// A string of markdown documentation.
  final String? markdownString;

  /// A [Widget] to render as documentation for ultimate flexibility.
  final Widget? docWidget;

  Documentable({this.markdownFile, this.markdownString, this.docWidget});
}
