import 'package:flutter/material.dart';

import '../bridge/dash_bridge.dart';

class TuneScreen extends StatefulWidget {
  const TuneScreen({super.key});

  @override
  State<TuneScreen> createState() => _TuneScreenState();
}

class _TuneScreenState extends State<TuneScreen> {
  Future<void> _apply(String command) async {
    final BridgeResult reply = await DashBridge.instance.send(command);
    if (!mounted || reply.ok) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(reply.error ?? 'Dash refused the command')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tune')),
      body: ListView(
        children: <Widget>[
          for (final MapEntry<String, String> action in <String, String>{
            'Performance': 'SET perf 1',
            'Balanced': 'SET perf 0',
            'Touch boost': 'SET touch 3',
            'Bypass charging': 'SET charging.bypass 1',
          }.entries)
            ListTile(
              title: Text(action.key),
              onTap: () => _apply(action.value),
            ),
        ],
      ),
    );
  }
}
