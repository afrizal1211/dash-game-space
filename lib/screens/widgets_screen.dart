import 'package:flutter/material.dart';

const List<String> widgetGroups = <String>[
  'FPS',
  'CPU / GPU gauges',
  'Performance mode',
  'Brightness',
  'Volume',
  'Capture',
  'Cleanup / charge',
  'Anti-interference',
  'Live monitor',
  'Crosshair',
  'RGB / colour',
  'Network / thermal',
];

class WidgetsScreen extends StatelessWidget {
  const WidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widgets')),
      body: GridView.count(
        key: const Key('widget-groups'),
        crossAxisCount: 2,
        padding: const EdgeInsets.all(12),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: <Widget>[
          for (final String group in widgetGroups)
            Card(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(group, textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    const Text(
                      'unavailable',
                      style: TextStyle(fontSize: 11, color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
