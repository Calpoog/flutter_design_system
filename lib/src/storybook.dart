import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/models/story.dart';
import 'package:flutter_design_system/src/routing/route_parser.dart';
import 'package:flutter_design_system/src/routing/router_delegate.dart';
import 'package:flutter_design_system/src/explorer/explorer_items.dart';
import 'package:flutter_design_system/src/canvas/background_popup.dart';
import 'package:flutter_design_system/src/canvas/viewport_popup.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_design_system/src/explorer/explorer.dart';

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
          'Mobile': const Size(320, 568),
          'Large Mobile': const Size(414, 896),
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

class Storybook extends StatefulWidget {
  Storybook({
    Key? key,
    required this.explorer,
    StorybookConfig? config,
  }) : super(key: key) {
    this.config = config ?? StorybookConfig();

    _processItems(explorer, '');
  }

  final List<ExplorerItem> explorer;
  final Map<String, Story> stories = {};
  late final StorybookConfig config;

  // Builds the string path for each item and stores a flat list of stories for routing
  _processItems(List<ExplorerItem> items, String path) {
    for (int i = 0; i < items.length; i++) {
      ExplorerItem item = items[i];
      item.path = '$path/${item.name}';

      if (item is Story) stories[item.path] = item;

      if (item.children != null) {
        _processItems(item.children!, item.path);
      }
    }
  }

  @override
  State<Storybook> createState() => _StorybookState();
}

class _StorybookState extends State<Storybook> {
  final navKey = GlobalKey<NavigatorState>();
  final appState = AppState();
  late final routeInformationParser = StoryRouteInformationParser();
  late final routerDelegate = StoryRouterDelegate(
    stories: widget.stories,
    navigatorKey: navKey,
    state: appState,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.nunitoSansTextTheme(
      Theme.of(context).textTheme.copyWith(subtitle1: const TextStyle(fontSize: 14)),
    );
    final theme = AppTheme();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OverlayNotifier()),
        ChangeNotifierProvider.value(value: appState),
        Provider.value(value: widget.explorer),
        Provider.value(value: theme),
        Provider.value(value: widget.config),
      ],
      builder: (context, _) => MaterialApp.router(
        routeInformationParser: routeInformationParser,
        routerDelegate: routerDelegate,
        title: 'Storybook',
        theme: ThemeData(
          textTheme: textTheme,
          iconTheme: IconThemeData(color: theme.unselected, size: 25),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          }),
          radioTheme: RadioThemeData(
              fillColor: MaterialStateProperty.resolveWith(
                  (states) => states.contains(MaterialState.selected) ? theme.selected : theme.inputBorder),
              overlayColor: MaterialStateProperty.all(theme.selected.withOpacity(0.2))),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(10, 48),
              side: BorderSide(color: theme.inputBorder),
              primary: theme.body,
              backgroundColor: theme.inputBorder.withOpacity(0.03),
              textStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
            ),
          ),
          primaryColor: theme.selected,
          unselectedWidgetColor: theme.unselected,
          listTileTheme: const ListTileThemeData(dense: true),
          // errorColor: ,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.inputBorder),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            // contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
        builder: (context, child) {
          final theme = context.read<AppTheme>();
          return Scaffold(
            backgroundColor: theme.background,
            body: GestureDetector(
              onTap: () {
                context.read<OverlayNotifier>().close();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 230,
                      child: Explorer(
                        items: context.read<List<ExplorerItem>>(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              offset: Offset(0, 1),
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                              create: (context) => ViewportNotifier(
                                appState.globals,
                                context.read<StorybookConfig>(),
                              ),
                            ),
                            ChangeNotifierProvider(create: (context) => BackgroundNotifier()),
                          ],
                          child: child,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
