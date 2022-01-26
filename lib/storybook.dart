import 'package:flutter/material.dart';
import 'package:flutter_storybook/main.dart';
import 'package:flutter_storybook/ui/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/story.dart';
import 'ui/component_view.dart';
import 'ui/explorer.dart';

class StorybookConfig {
  late final Map<String, Size> deviceSizes;
  late final Map<String, Color> backgrounds;
  final EdgeInsets componentPadding;

  StorybookConfig({
    Map<String, Size>? deviceSizes,
    Map<String, Color>? backgrounds,
    this.componentPadding = EdgeInsets.zero,
  }) {
    this.backgrounds = backgrounds ??
        {
          'Dark': Colors.black,
          'Light': Colors.white,
        };
    this.deviceSizes = deviceSizes ??
        {
          'Mobile ': const Size(320, 568),
          'Large Mobile ': const Size(414, 896),
          'Tablet': const Size(834, 1112),
        };
  }
}

class OverlayNotifier extends ChangeNotifier {
  OverlayEntry? entry;

  void add(BuildContext context, OverlayEntry entry) {
    this.entry?.remove();
    Overlay.of(context)!.insert(entry);
    this.entry = entry;
    notifyListeners();
  }

  void close() {
    entry?.remove();
    entry = null;
    notifyListeners();
  }
}

class Storybook extends StatelessWidget {
  Storybook({
    Key? key,
    required this.explorer,
    Map<String, Size>? deviceSizes,
    StorybookConfig? config,
  }) : super(key: key) {
    this.config = config ?? StorybookConfig();
  }

  final List<Organized> explorer;
  late final StorybookConfig config;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoryNotifier(buttonComponent.stories.first)),
        ChangeNotifierProvider(create: (_) => OverlayNotifier()),
        Provider(create: (_) => AppTheme()),
        Provider.value(value: config),
      ],
      builder: (context, _) {
        final theme = context.read<AppTheme>();
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            textTheme: GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),
            iconTheme: IconThemeData(color: theme.unselected, size: 25),
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.border),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              contentPadding: const EdgeInsets.all(14),
              isDense: true,
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
            ),
            tabBarTheme: TabBarTheme(
              labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 3.0,
                    color: theme.selected,
                  ),
                ),
              ),
              labelColor: theme.selected,
              labelStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
              unselectedLabelColor: theme.unselected,
              unselectedLabelStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
            ),
          ),
          home: Scaffold(
            backgroundColor: theme.background,
            body: GestureDetector(
              onTap: () => context.read<OverlayNotifier>().close(),
              child: SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 240,
                      child: Explorer(
                        items: explorer,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          elevation: 2,
                          color: Colors.white,
                          child:
                              context.watch<StoryNotifier>().story != null ? const ComponentView() : const SizedBox(),
                        ),
                      ),
                    ),
                    // ComponentView(component: component, storyName: storyName)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
