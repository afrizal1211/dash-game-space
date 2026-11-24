import 'package:flutter/material.dart';

import '../bridge/dash_bridge.dart';

class MacroPanel extends StatelessWidget {
  const MacroPanel({required this.package, super.key});

  final String package;

  Future<void> _arm() {
    final String json =
        '{"package":"$package","action":"tap","x":10,"y":10}';
    return DashBridge.instance.send('ACTION input.inject $json');
  }

  Future<void> _release() =>
      DashBridge.instance.send('ACTION game.session.release');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Macro session'),
      content: Text('Foreground: $package'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            _release();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            _arm();
            Navigator.of(context).pop();
          },
          child: const Text('Arm'),
        ),
      ],
    );
  }
}
