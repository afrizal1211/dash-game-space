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
      body: SingleChildScrollView(
        key: const Key('widget-groups'),
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            for (final String group in widgetGroups)
              SizedBox(
                width: 160,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
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
              ),
          ],
        ),
      ),
    );
  }
}
