import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';

class Documentation extends Story {
  Documentation({required String name, String? markdownFile, String? markdownString, Widget? docWidget})
      : assert(markdownFile != null || markdownString != null || docWidget != null,
            'One of markdownString, markdownFile, or docWidget must be provided.'),
        super(name: name, markdownFile: markdownFile, markdownString: markdownString, docWidget: docWidget);
}
