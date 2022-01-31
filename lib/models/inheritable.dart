import 'package:flutter/material.dart';
import 'package:flutter_storybook/models/arguments.dart';

/// A set of properties for configuring Stories that can be defined at the
/// Storybook, Component, and Story level and are inherited.
abstract class InheritableStorybook {
  final EdgeInsets? componentPadding;

  InheritableStorybook({this.componentPadding});
}

/// A set of properties for configuring Stories that can be defined at the
/// Component and Story level and are inherited.
abstract class InheritableComponent {
  final TemplateBuilder? builder;

  InheritableComponent({this.builder});
}
