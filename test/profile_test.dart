import 'package:flutter_test/flutter_test.dart';
import 'package:dash_game_space/data/profile.dart';

void main() {
  test('profile round trips through JSON', () {
    const GameProfile profile = GameProfile(
      package: 'com.game',
      cpuMode: 2,
      gpuMode: 1,
      touchMode: 3,
    );
    final GameProfile restored = GameProfile.fromJson(profile.toJson());
    expect(restored, profile);
  });

  test('default profile fills missing fields', () {
    final GameProfile profile = GameProfile.fromJson(<String, dynamic>{
      'package': 'com.game',
    });
    expect(profile.cpuMode, 0);
    expect(profile.gpuMode, 0);
    expect(profile.touchMode, 0);
  });

  test('unknown keys are dropped', () {
    final GameProfile profile = GameProfile.fromJson(<String, dynamic>{
      'package': 'com.game',
      'unknownKey': 'nope',
    });
    expect(profile.toJson().containsKey('unknownKey'), isFalse);
  });
}
