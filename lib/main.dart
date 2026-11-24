import 'package:flutter/material.dart';

import 'bridge/dash_bridge.dart';

void main() => runApp(const GameSpaceApp());

class GameSpaceApp extends StatefulWidget {
  const GameSpaceApp({super.key});

  @override
  State<GameSpaceApp> createState() => _GameSpaceAppState();
}

class _GameSpaceAppState extends State<GameSpaceApp> {
  Set<String> _capabilities = <String>{};
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _probe();
  }

  Future<void> _probe() async {
    final Set<String> capabilities = await DashBridge.instance.capabilities();
    if (!mounted) return;
    setState(() {
      _capabilities = capabilities;
      _checked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool dashReady = _capabilities.isNotEmpty;
    return MaterialApp(
      title: 'Dash Game Space',
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('Dash Game Space')),
        body: Center(
          child: !_checked
              ? const CircularProgressIndicator()
              : dashReady
                  ? Text('Dash connected — ${_capabilities.length} capabilities')
                  : const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Dash Essential unavailable. Local-only basic mode.',
                        textAlign: TextAlign.center,
                      ),
                    ),
        ),
      ),
    );
  }
}
