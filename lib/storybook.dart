import 'package:flutter/material.dart';
import 'package:flutter_storybook/ui/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/story.dart';
import 'ui/component_view.dart';
import 'ui/explorer.dart';

class Storybook extends StatelessWidget {
  const Storybook({Key? key, required this.explorer}) : super(key: key);

  final List<Organized> explorer;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoryNotifier()),
        Provider(create: (_) => AppTheme()),
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
