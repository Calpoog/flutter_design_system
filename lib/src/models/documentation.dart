import 'package:flutter/material.dart';
// ignore: prefer_relative_imports
import 'package:flutter_design_system/flutter_design_system.dart';

/// A documentation-only form of a [Story].
///
/// [Documentation] can be used as an item in the explorer. It will not have a
/// canvas preview.
class Documentation extends Story {
  Documentation({required String name, String? markdownFile, String? markdownString, Widget? docWidget})
      : assert(markdownFile != null || markdownString != null || docWidget != null,
            'One of markdownString, markdownFile, or docWidget must be provided.'),
        super(name: name, markdownFile: markdownFile, markdownString: markdownString, docWidget: docWidget);
}
