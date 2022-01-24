import 'package:flutter/material.dart';
import 'package:flutter_storybook/component.dart';
import 'package:flutter_storybook/ui/component_view.dart';
import 'package:provider/provider.dart';

import 'ui/explorer.dart';

class StoryNotifier extends ChangeNotifier {
  Story? story;

  void update(Story story) {
    this.story = story;
    debugPrint('Selected $story ${story.toString()}');
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
            create: (_) => StoryNotifier(),
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
                      child: context.watch<StoryNotifier>().story != null ? const ComponentView() : const SizedBox(),
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
