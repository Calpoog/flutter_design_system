# Flutter Design System

A Storybook inspired design system tool for building Flutter UI components faster and in isolation. Create developer and designer documentation all in one place.

Write stories which highlight UI component variants, functionality, and use cases. Preview your components in a canvas with real-time editing of inputs to develop and test independent from your application.

- [Flutter Design System](#flutter-design-system)
  - [Preface](#preface)
  - [Installation](#installation)
  - [What is a design system](#what-is-a-design-system)
  - [Getting started](#getting-started)
    - [First design system widget](#first-design-system-widget)
    - [Write the `Component`](#write-the-component)
      - [Component documentation](#component-documentation)
      - [The `builder`](#the-builder)
      - [Args definitions](#args-definitions)
      - [Stories](#stories)
    - [Add the `Component` to the design system](#add-the-component-to-the-design-system)
  - [Organize your design system (explorer)](#organize-your-design-system-explorer)
    - [`Root`](#root)
    - [`Folder`](#folder)
    - [`Documentation`](#documentation)
    - [`Component`](#component)
    - [`Story`](#story)
  - [Controls](#controls)
  - [DocsPage](#docspage)
  - [Check out the example](#check-out-the-example)

## Preface
This package is intended to be used in a separate application from your main app to organize and document your design system components. If necessary for it to exist within your app files, it's recommended to have another Flutter sub-project.

## Installation

Add `flutter_design_system` to your dependencies in `pubspec.yaml`
```yaml
dependencies:
  flutter_design_system: ^0.0.1
```

Add the design system fonts to your `pubspec.yaml`
```yaml
fonts:
  - family: NunitoSans
    fonts:
      - asset: packages/flutter_design_system/fonts/NunitoSans-Regular.ttf
      - asset: packages/flutter_design_system/fonts/NunitoSans-SemiBold.ttf
      - asset: packages/flutter_design_system/fonts/NunitoSans-Bold.ttf
      - asset: packages/flutter_design_system/fonts/NunitoSans-Black.ttf
      - asset: packages/flutter_design_system/fonts/NunitoSans-ExtraBold.ttf
  - family: RobotoMono
    fonts:
      - asset: packages/flutter_design_system/fonts/RobotoMono-Regular.ttf
```

## What is a design system

We'll define a design system as a container for your components and their documentation in the form of stories. You'll write some metadata about the components you want to show off in your design system. Then you'll write some *stories* which can be documentation-only (for higher level design system guidelines) or to highlight the ways your components can be used (demonstrating important variants or showing how components may work together). You'll organize your stories for discoverability. Finally, you can preview your stories, change their values in real-time, and view your design system documentation.

## Getting started
### First design system widget

First, let's assume we have a Widget we want in our design system. In this case we'll use something simple: A widget which displays an icon in a colored circle background:
```dart
class CircleIcon extends StatelessWidget {
  const CircleIcon({
    Key? key,
    required this.icon,
    required this.backgroundColor,
    this.size = 40,
    required this.tooltipText,
  }) : super(key: key);

  final IconData icon;
  final Color backgroundColor;
  final double size;
  final String tooltipText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(size / 2),
        ),
      ),
      child: Tooltip(
        child: Icon(icon),
        message: tooltipText,
      ),
    );
  }
}
```

### Write the `Component`
A `Component` is metadata like documentation, argument definitions, and how to build our widget for viewing.

We want to describe our `CircleIcon` widget for use in the design system as follows:
```dart
final circleIconComponent = Component(
  name: 'CircleIcon',
  markdownString: 'An icon displayed in a colored circle.',
  builder: (BuildContext context, Arguments args, Globals globals) {
    return CircleIcon(
      icon: args.value('icon'),
      backgroundColor: args.value('backgroundColor'),
      size: args.value('size'),
      tooltipText: args.value('tooltipText'),
    );
  },
  argTypes: [
    ArgType(
      name: 'icon',
      description: 'The icon to display',
      isRequired: true,
    ),
    ArgType(
      name: 'backgroundColor',
      description: 'The color of the circle behind the icon',
      isRequired: true,
    ),
    ArgType(
      name: 'size',
      description: 'The diameter of the circle',
      defaultValue: 40,
    ),
    ArgType(
      name: 'tooltipText',
      description: 'The text to display in a tooltip when the cirlce is hovered',
      isRequired: true,
    ),
  ],
  stories: [
    Story(
      name: 'Basic',
      args: {
        'icon': Icons.message,
        'backgroundColor': Colors.amber,
        'tooltipText': 'Message',
      },
    ),
    Story(
      name: 'Error',
      markdownString: 'Used to indicate in error in our app.',
      useControls: false,
      args: {
        'icon': Icons.warning,
        'backgroundColor': Colors.red,
        'tooltipText': 'Message',
      },
    ),
  ],
);
```
#### Component documentation
The component metadata defines a name string. This usually is the name of a widget that this component represents, but when writing components that demonstrate larger concepts like multiple widgets together or an application page, it can be whatever you'd like to display in the design system's explorer panel and documentation. In addition, markdown documentation can be added in the form of a string, as well as from a file in the `assets` folder, or from a widget.

#### The `builder`
The `builder` argument defines how to build our `CircleIcon` widget for the design system canvas preview. This builder function receives a `BuildContext`, `Arguments`, and `Globals`. The `Arguments` object is important for retrieving values set for the widget's documented arguments by `Story`s that are defined later. Lastly, `Globals` contains values that are set by the design system's tools, like viewport size or theme – which can be used to affect the rendered widget. Rather than hardcoding values for `CircleIcon`'s constructor arguments, we retrieve the arg values with `args.value('arg name')`. This allows multiple `Story`s to use this `builder` when rendering in the preview while also providing unique values for the args on a per-story basis.

#### Args definitions
Widgets have arguments to control their display and behavior. Our `CircleIcon` has four arguments. The design system can display these arguments as documentation. In addition, defining them here allows `Story`s to map values to them that will then be used when each `Story` is rendered in the design system preview.

Arg definitions take the form of an `ArgType` object that specifies important metadata about each arg. We can provide name, description, defaults, whether it's required, and more.

#### Stories
Last in this component metadata is the list of `Story`s. This is the most important building block of the design system. It can be as simple as a single `Story` to render one version of the component. More likely, there may be multiple stories to tell about a single component (like a Primary, Secondary, or Tertiary story for a Button component). You can define as many stories as you want. The story can specify a map of args which will be delivered to the `Component`s `builder` function.

In our example, the `CircleIcon` has two stories. One which demonstrates basic behavior, and another which calls out a specific use case in our design system. The second story has story-specific markdownand turns off the ability to change its arguments in the preview by setting `useControls: false`.

### Add the `Component` to the design system
The above is an extremely simple example of a component definition and stories. But before we go further on any topic, let's add it to our design system so we can see it in the explorer and preview. Your design system app will almost always render a single widget - `DesignSystem`, where you'll provide your organizational structure and any config.
```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DesignSystem(
      explorer: [
        circleIconComponent,
      ],
    );
  }
}
```

This is all that's necessary to get a basic design system running. When you run your app, you should see a single component dropdown with two stories in the explorer pane on the left. When you select a story you should be able to see the `CircleIcon` widget in the canvas preview on the right, with all it's arguments correctly set from the `Story` `args`. Lastly, you'll see an auto-generated DocsPage in the Docs tab on the right. A DocsPage shows all stories for the component, regardless of which story you're viewing. The first story is considered the "primary" story and is highlighted first, followed by any others.

## Organize your design system (explorer)
Organization is very important in a design system so that the consumers (both designers and developers) can find what they are looking for. The explorer panel on the left side of the design system can organize your components and stories in a tree structure for best discoverability. The `explorer` argument for the `DesignSystem` widget can take any explorer item: `Root`, `Folder`, `Documentation`, and `Component`. A `Story` is also an explorer item, but they are populated under `Components` implicitly.

### `Root`
A top-level-only expandable grouping for other explorer items. It can't be nested under another `Root` or `Folder`. You do not need to have any `Root`s in your explorer – it's purely for if you prefer the visual organization.

### `Folder`
A folder is another expandable item, but can exist at the top-level or nested in a `Root` or other `Folder`s. It can contain other `Folder`s as well as `Component`s.

### `Documentation`
Documentation is a standalone explorer item that, when selected, only has a Docs tab in the preview panel, but no canvas. Use it to write design system documentation that does not necessarily apply to a component or stories. It cannot have any nested items.

### `Component`
A component usually describes a single widget and can have several stories to highlight important varants or use cases. It can also be used in a more abstract way and have a builder which shows multiple widgets in use together, or entire pages. It can have any number of `Story`s, and as we saw above, provides config and argument definitions that the children stories then use.

A `Component` will show as an expandable grouping of stories in the explorer. However, if there is only one story and its `name` argument matches the `name` of the `Component`, it will be collapsed visually and only show a single story item without it being nested under a component. It can only have `Story`s as children (it cannot have `Root` or `Folder`).

### `Story`
A `Story` explorer item can only exist as a child of a `Component` (though it may show independently as mentioned above). A story is the only selectable item in the explorer and will be previewed in the right panel.

## Controls
When you define a `Component` and its args with `ArgTypes`, it doesn't just provide a nice argument definitions table to your canvas and DocsPage. It also will implicitly try to create controls that allow the args to be modified in the canvas. By default, ArgTypes with `<T>` of `String`, `double`, `int`, `number`, and `bool` will implicitly get a control assigned. In addition, args with a `mapping` property can map Strings to a complex type (like a color name to a `Color`) will implicitly get a dropdown select control. When you provide a mapping it does not need to be and exhaustive map of values, just what you want your design system users to be able to play with in the canvas.

In some cases you may want to set the control type explicitly. You can turn off a control on any ArgType with the `control` property set to `Controls.none()`. `Controls.boolean()`, `Controls.text()`, `Controls.number()` are also available but will never need set if you leave `control` as null and allow the design system to choose. `Controls.select()` is used by default for `ArgType`s with a `mapping`, but you can explicitly use `Controls.radio()` to show the options as a radio list instead.

You can turn controls off for an entire story by setting `useControls: false` on the `Story`. If a component's args all have no controls, the controls panel at the bottom of the canvas will not be shown. The argument definition table will still be shown in the DocsPage.

More controls for other common types may be added in the future (`Color`, `EdgeInsets`, etc).

## DocsPage
By default, each `Component` will get an auto-generated DocsPage, viewable on the Docs tab in the preview panel when one of its `Story`s is selected. The page has several sections, generated as follows:

1. Name of the `Component`
2. `Component` documentation
   - The documentation will conditionally show the docs (if provided) from the `docWidget`, then `markdownFile`, and lastly `markdownString`.
3. A canvas preview and args definition table for the "primary" story. The primary story is the first story in the `Component`'s `children`.
4. The documentation for the primary story.
   - Same as for `Component`
5. A list of the rest of the stories (if any)
   - Each `Story` shows its name, documentation, and a canvas preview.

## Check out the example
For a deeper example with several stories, documentation pages, and controls, check out and run the example application.