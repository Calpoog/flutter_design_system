import 'package:flutter/material.dart';
import 'package:flutter_storybook/component.dart';
import 'package:flutter_storybook/ui/component_view.dart';
import 'package:provider/provider.dart';

import 'ui/explorer.dart';

class SelectedComponent extends ChangeNotifier {
  ComponentMeta? component;
  Story? story;

  void update({ComponentMeta? component, String storyName = 'Default'}) {
    this.component = component;
    if (component != null) {
      story = component.stories[storyName];
    }
    debugPrint('Selected $story ${component.toString()}');
    notifyListeners();
  }
}

class Storybook extends StatelessWidget {
  const Storybook({Key? key, required this.explorer}) : super(key: key);

  final List<Organized> explorer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(246, 249, 252, 1),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (_) => SelectedComponent(),
            builder: (BuildContext context, Widget? child) => Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 300,
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
                      child: context.watch<SelectedComponent>().component != null
                          ? const ComponentView()
                          : const SizedBox(),
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
  }
}
