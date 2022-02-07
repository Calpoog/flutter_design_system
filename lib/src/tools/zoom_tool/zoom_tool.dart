import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/tools/models/tool.dart';
import 'package:provider/provider.dart';

List<Tool> zoomTools() => [
      Tool(
        name: 'Zoom in',
        icon: Icons.zoom_in_outlined,
        onPressed: (context) => context.read<ZoomProvider>().adjustZoom(0.2),
      ),
      Tool(
        name: 'Zoom out',
        icon: Icons.zoom_out_outlined,
        onPressed: (context) => context.read<ZoomProvider>().adjustZoom(-0.2),
      ),
      Tool(
        name: 'Reset zoom',
        icon: Icons.youtube_searched_for_outlined,
        onPressed: (context) => context.read<ZoomProvider>().setZoom(1.0),
        divide: true,
      )
    ];

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
