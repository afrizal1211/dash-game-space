import 'package:flutter/material.dart';

import 'bridge/dash_bridge.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

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
    return MaterialApp(
      title: 'Dash Game Space',
      theme: GameSpaceTheme.dark(),
      home: _checked
          ? const HomeScreen()
          : const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}
