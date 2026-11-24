import 'package:flutter/material.dart';

import '../bridge/dash_bridge.dart';

class MacroPanel extends StatelessWidget {
  const MacroPanel({required this.package, super.key});

  final String package;

  Future<void> _arm() {
    return DashBridge.instance.send(
      '{"package":"$package","action":"tap","x":0,"y":0}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Macro session'),
      content: Text('Foreground: $package'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
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
