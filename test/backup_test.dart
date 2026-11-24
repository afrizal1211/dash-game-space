import 'package:flutter_test/flutter_test.dart';
import 'package:dash_game_space/data/backup.dart';

void main() {
  test('Game Space backup is separate from Dash backup', () {
    final GameSpaceBackup backup = GameSpaceBackup(
      games: const <String>['com.game'],
      widgets: const <String>['FPS'],
    );
    final Map<String, dynamic> raw = backup.toJson();
    expect(raw.containsKey('saveBundle'), isFalse);
    expect(GameSpaceBackup.fromJson(raw), backup);
  });

  test('import needs an explicit confirmation token', () {
    expect(GameSpaceBackup.importCommand(confirm: false), isNull);
    expect(
      GameSpaceBackup.importCommand(confirm: true),
      'ACTION import.apply confirm',
    );
  });
}
