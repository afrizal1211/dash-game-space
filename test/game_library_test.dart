import 'package:flutter_test/flutter_test.dart';
import 'package:dash_game_space/data/game_library.dart';

void main() {
  test('game list filters system overlays and keeps launchable apps', () async {
    const String payload = '''
[
  {"package":"com.game.one","system":false,"launchable":true},
  {"package":"com.android.contactspicker","system":true,"launchable":false},
  {"package":"com.miui.powerkeeper","system":true,"launchable":false},
  {"package":"android.miui.overlay","system":true,"launchable":false},
  {"package":"com.user.tool","system":false,"launchable":false}
]
''';
    final List<GameEntry> games = await GameLibrary(
      command: (String command) async =>
          BridgeResult(ok: true, result: payload),
    ).load();
    expect(games.map((GameEntry game) => game.package), <String>[
      'com.game.one',
      'com.user.tool',
    ]);
  });
}
