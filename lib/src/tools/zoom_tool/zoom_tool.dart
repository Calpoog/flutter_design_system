import 'package:flutter/material.dart';
import '../models/tool.dart';
import 'package:provider/provider.dart';

List<Widget> zoomTools() => const [
      ZoomInTool(),
      ZoomOutTool(),
      ZoomResetTool(),
    ];

class ZoomInTool extends StatelessWidget {
  const ZoomInTool({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tool(
      name: 'Zoom in',
      icon: Icons.zoom_in_outlined,
      onPressed: () => context.read<ZoomProvider>().adjustZoom(0.2),
    );
  }
}

class ZoomOutTool extends StatelessWidget {
  const ZoomOutTool({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tool(
      name: 'Zoom out',
      icon: Icons.zoom_out_outlined,
      onPressed: () => context.read<ZoomProvider>().adjustZoom(-0.2),
    );
  }
}

class ZoomResetTool extends StatelessWidget {
  const ZoomResetTool({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tool(
      name: 'Reset zoom',
      icon: Icons.youtube_searched_for_outlined,
      onPressed: () => context.read<ZoomProvider>().setZoom(1.0),
    );
  }
}

class ZoomProvider extends ChangeNotifier {
  double zoom = 1.0;

  setZoom(double zoom) {
    this.zoom = zoom;
    notifyListeners();
  }

  adjustZoom(double amount) {
    zoom += amount;
    notifyListeners();
  }
}
