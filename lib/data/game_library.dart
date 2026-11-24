import 'dart:convert';

import '../bridge/dash_bridge.dart';

typedef GameCommand = Future<BridgeResult> Function(String command);

class GameEntry {
  const GameEntry({required this.package, required this.label});

  final String package;
  final String label;

  static GameEntry fromJson(Map<String, dynamic> raw) {
    final String package = raw['package']?.toString() ?? '';
    return GameEntry(
      package: package,
      label: raw['label']?.toString() ?? package,
    );
  }
}

class GameLibrary {
  GameLibrary({GameCommand? command})
      : _command = command ?? DashBridge.instance.send;

  final GameCommand _command;

  Future<List<GameEntry>> load() async {
    final BridgeResult reply = await _command('GET app.list');
    if (!reply.ok || reply.result == null) return const <GameEntry>[];
    try {
      final Object? decoded = jsonDecode(reply.result!);
      if (decoded is! List) return const <GameEntry>[];
      return decoded
          .whereType<Map<String, dynamic>>()
          .where((Map<String, dynamic> app) {
            final String package = app['package']?.toString() ?? '';
            if (package.isEmpty) return false;
            final bool system = app['system'] == true;
            final bool launchable = app['launchable'] == true;
            return launchable || !system;
          })
          .map(GameEntry.fromJson)
          .toList(growable: false);
    } catch (_) {
      return const <GameEntry>[];
    }
  }
}
