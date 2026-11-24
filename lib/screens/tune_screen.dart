import 'package:flutter/material.dart';

import '../bridge/dash_bridge.dart';
import '../theme.dart';
import '../widgets/game_backdrop.dart';

class TuneScreen extends StatefulWidget {
  const TuneScreen({super.key});

  @override
  State<TuneScreen> createState() => _TuneScreenState();
}

class _TuneScreenState extends State<TuneScreen> {
  String _selected = 'Performance';

  static const Map<String, String> _actions = <String, String>{
    'Performance': 'SET perf 1',
    'Balanced': 'SET perf 0',
    'Touch boost': 'SET touch 3',
    'Bypass charging': 'SET charging.bypass 1',
  };

  Future<void> _apply(String label, String command) async {
    final BridgeResult reply = await DashBridge.instance.send(command);
    if (!mounted || reply.ok) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(reply.error ?? 'Dash refused the command'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Tune')),
      body: GameBackdrop(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Choose the active profile',
                style: TextStyle(color: GameSpaceTheme.muted, fontSize: 13),
              ),
            ),
            for (final MapEntry<String, String> action in _actions.entries)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: GameSpaceTheme.panel(active: action.key == _selected),
                child: ListTile(
                  leading: action.key == _selected
                      ? Icon(
                          Icons.check_circle,
                          key: Key('tune-active-${action.key}'),
                          color: GameSpaceTheme.accent,
                        )
                      : const Icon(Icons.radio_button_unchecked),
                  title: Text(
                    action.key,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  selected: action.key == _selected,
                  onTap: () {
                    setState(() => _selected = action.key);
                    _apply(action.key, action.value);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
