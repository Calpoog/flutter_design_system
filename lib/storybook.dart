import 'package:flutter/material.dart';
import 'package:flutter_storybook/main.dart';
import 'package:flutter_storybook/ui/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/story.dart';
import 'ui/component_view.dart';
import 'ui/explorer.dart';

class StorybookConfig {
  final Map<String, Size> deviceSizes;

  StorybookConfig({required this.deviceSizes});
}

class Storybook extends StatelessWidget {
  Storybook({Key? key, required this.explorer, Map<String, Size>? deviceSizes}) : super(key: key) {
    this.deviceSizes = deviceSizes ??
        {
          'Mobile ': const Size(320, 568),
          'Large Mobile ': const Size(414, 896),
          'Tablet': const Size(834, 1112),
        };
  }

  final List<Organized> explorer;
  late final Map<String, Size> deviceSizes;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoryNotifier(buttonComponent.stories.first)),
        Provider(create: (_) => AppTheme()),
        Provider(
          create: (_) => StorybookConfig(deviceSizes: deviceSizes),
        ),
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
            body: SafeArea(
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
                        child: context.watch<StoryNotifier>().story != null ? const ComponentView() : const SizedBox(),
                      ),
                    ),
                  ),
                  // ComponentView(component: component, storyName: storyName)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
