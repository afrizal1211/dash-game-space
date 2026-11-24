import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class GameSpaceBackup {
  const GameSpaceBackup({
    this.games = const <String>[],
    this.widgets = const <String>[],
  });

  final List<String> games;
  final List<String> widgets;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'games': games,
        'widgets': widgets,
      };

  static GameSpaceBackup fromJson(Map<String, dynamic> raw) {
    final List<String> games = (raw['games'] as List?)
            ?.whereType<String>()
            .toList(growable: false) ??
        const <String>[];
    final List<String> widgets = (raw['widgets'] as List?)
            ?.whereType<String>()
            .toList(growable: false) ??
        const <String>[];
    return GameSpaceBackup(games: games, widgets: widgets);
  }

  static GameSpaceBackup decode(String raw) {
    final Object? decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return const GameSpaceBackup();
    return fromJson(decoded);
  }

  String encode() => jsonEncode(toJson());

  static String importCommand(String token) => 'ACTION import.apply $token';

  @override
  bool operator ==(Object other) =>
      other is GameSpaceBackup &&
      listEquals(other.games, games) &&
      listEquals(other.widgets, widgets);

  @override
  int get hashCode => Object.hash(Object.hashAll(games), Object.hashAll(widgets));
}
