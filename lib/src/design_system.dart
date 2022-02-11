import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';
import 'package:flutter_design_system/src/routing/route_parser.dart';
import 'package:flutter_design_system/src/routing/router_delegate.dart';
import 'package:flutter_design_system/src/tools/viewport_tool/viewport_tool.dart';
import 'package:flutter_design_system/src/tools/zoom_tool/zoom_tool.dart';
import 'package:flutter_design_system/src/ui/component_view.dart';
import 'package:flutter_design_system/src/ui/utils/section.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_design_system/src/explorer/explorer.dart';

class DesignSystemConfig {
  late final Map<String, Size> deviceSizes;
  late final Map<String, ThemeData> themes;
  final EdgeInsets componentPadding;
  late final List<Decorator> decorators;

  DesignSystemConfig({
    Map<String, Size>? deviceSizes,
    Map<String, ThemeData>? themes,
    this.componentPadding = EdgeInsets.zero,
    List<Decorator>? decorators,
  }) {
    this.themes = themes ??
        {
          'Dark': ThemeData.dark(),
          'Light': ThemeData.light(),
        };
    this.deviceSizes = deviceSizes ??
        {
          'Mobile': const Size(320, 568),
          'Large Mobile': const Size(414, 896),
          'Tablet': const Size(834, 1112),
        };
    this.decorators = decorators ?? [];
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
  }
}

class DesignSystem extends StatefulWidget {
  DesignSystem({
    Key? key,
    required this.explorer,
    DesignSystemConfig? config,
  }) : super(key: key) {
    this.config = config ?? DesignSystemConfig();

    _processItems(explorer, '');
  }

  final List<ExplorerItem> explorer;
  final Map<String, Story> stories = {};
  late final DesignSystemConfig config;

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
  State<DesignSystem> createState() => _DesignSystemState();
}

class _DesignSystemState extends State<DesignSystem> {
  late final appState = AppState();
  late final routeInformationParser = StoryRouteInformationParser();
  late final routerDelegate = StoryRouterDelegate(
    stories: widget.stories,
    state: appState,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.copyWith(subtitle1: const TextStyle(fontSize: 14));
    final theme = AppTheme();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OverlayNotifier()),
        ChangeNotifierProvider.value(value: appState),
        ChangeNotifierProvider.value(value: appState.globals),
        Provider.value(value: widget.explorer),
        Provider.value(value: theme),
        Provider.value(value: widget.config),
      ],
      builder: (context, _) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: routeInformationParser,
        routerDelegate: routerDelegate,
        title: 'DesignSystem',
        theme: ThemeData(
          textTheme: textTheme,
          fontFamily: 'NunitoSans',
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
              textStyle: const TextStyle(fontFamily: 'NunitoSans', fontWeight: FontWeight.bold),
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
            labelStyle: const TextStyle(fontFamily: 'NunitoSans', fontWeight: FontWeight.bold),
            unselectedLabelColor: theme.unselected,
            unselectedLabelStyle: const TextStyle(fontFamily: 'NunitoSans', fontWeight: FontWeight.bold),
          ),
        ),
        builder: (context, child) => DesignSystemHome(child: child),
      ),
    );
  }
}

class DesignSystemHome extends StatefulWidget {
  const DesignSystemHome({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  _DesignSystemHomeState createState() => _DesignSystemHomeState();
}

class _DesignSystemHomeState extends State<DesignSystemHome> {
  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return Overlay(
      initialEntries: [
        OverlayEntry(builder: (context) => widget.child ?? const SizedBox()),
        OverlayEntry(
          builder: (context) => Scaffold(
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
                        child: Section(
                          child: Consumer<AppState>(
                            builder: (context, appState, _) => MultiProvider(
                              providers: [
                                Provider.value(value: appState.story),
                                ChangeNotifierProvider(
                                  create: (context) => ZoomProvider(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => ViewportProvider(
                                    globals: appState.globals,
                                    config: context.read<DesignSystemConfig>(),
                                  ),
                                ),
                              ],
                              child: appState.story != null
                                  ? Consumer<AppState>(
                                      builder: (_, __, ___) => ComponentView(story: appState.story!),
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
