import 'package:flutter/material.dart';

class QuickSettings extends StatelessWidget {
  const QuickSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      key: const Key('quick-settings'),
      spacing: 8,
      children: const <Widget>[
        Chip(label: Text('Brightness')),
        Chip(label: Text('Volume')),
        Chip(label: Text('FPS')),
      ],
    );
  }
}
