import 'package:flutter/material.dart';

import '../bridge/dash_bridge.dart';
import '../theme.dart';
import '../widgets/game_backdrop.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key, this.capabilities = const <String>{}});

  final Set<String> capabilities;

  static const Map<String, String> _commands = <String, String>{
    'FPS': 'GET app.fps.light',
    'CPU / GPU gauges': 'GET health',
    'Performance mode': 'SET perf 1',
    'Brightness': 'SET display.brightness 180',
    'Volume': 'SET audio.volume 3 50',
    'Capture': 'GET health',
    'Cleanup / charge': 'SET charging.bypass 1',
    'Anti-interference': 'SET touch 3',
    'Live monitor': 'GET app.fps.light',
    'Crosshair': 'GET app.fps.light',
    'RGB / colour': 'SET display.color 0',
    'Network / thermal': 'GET health',
  };

  static const Map<String, String> _required = <String, String>{
    'FPS': 'fps',
    'CPU / GPU gauges': 'gpu',
    'Performance mode': 'perf',
    'Brightness': 'display',
    'Volume': 'audio',
    'Capture': 'capture',
    'Cleanup / charge': 'charging',
    'Anti-interference': 'touch',
    'Live monitor': 'fps',
    'Crosshair': 'touch',
    'RGB / colour': 'display',
    'Network / thermal': 'thermal',
  };

  Future<void> _run(BuildContext context, String label) async {
    final BridgeResult reply = await DashBridge.instance.send(_commands[label]!);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(reply.ok ? '$label applied' : (reply.error ?? 'Dash refused')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Performance')),
      body: GameBackdrop(
        child: SingleChildScrollView(
          key: const Key('widget-groups'),
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: <Widget>[
              for (final String group in _commands.keys)
                SizedBox(
                  width: 168,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: GameSpaceTheme.panel(
                      active: capabilities.contains(_required[group]),
                    ),
                    child: InkWell(
                    key: capabilities.contains(_required[group])
                        ? Key('widget-enabled-$group')
                        : Key('widget-disabled-$group'),
                    onTap: capabilities.contains(_required[group])
                        ? () => _run(context, group)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(group, textAlign: TextAlign.center),
                          const SizedBox(height: 6),
                          Text(
                            capabilities.contains(_required[group])
                                ? 'tap to apply'
                                : 'unavailable',
                            style: TextStyle(
                              fontSize: 11,
                              color: capabilities.contains(_required[group])
                                  ? Colors.greenAccent
                                  : Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
