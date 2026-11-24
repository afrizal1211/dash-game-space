import 'dart:convert';

import '../bridge/dash_bridge.dart';

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
  GameLibrary({DashBridge? bridge}) : _bridge = bridge ?? DashBridge.instance;

  final DashBridge _bridge;

  Future<List<GameEntry>> load() async {
    final BridgeResult reply = await _bridge.send('GET app.list');
    if (!reply.ok || reply.result == null) return const <GameEntry>[];
    try {
      final Object? decoded = jsonDecode(reply.result!);
      if (decoded is! List) return const <GameEntry>[];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(GameEntry.fromJson)
          .where((GameEntry entry) => entry.package.isNotEmpty)
          .toList(growable: false);
    } catch (_) {
      return const <GameEntry>[];
    }
  }
}
