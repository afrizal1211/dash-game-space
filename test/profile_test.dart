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

  test('profile uses the Dash profile payload shape', () {
    const GameProfile profile = GameProfile(
      package: 'com.game',
      gpuMode: 2,
      touchMode: 1,
    );
    final Map<String, dynamic> raw = profile.toJson();
    expect(raw['user'], 0);
    expect(raw['package'], 'com.game');
    expect(raw['profile'] is Map<String, dynamic>, isTrue);
    expect((raw['profile'] as Map<String, dynamic>)['touch'], 1);
    expect((raw['profile'] as Map<String, dynamic>)['gpu'], 2);
    expect(raw.containsKey('cpuMode'), isFalse);
  });

  test('mode values are clamped to Dash limits', () {
    final GameProfile profile = GameProfile.fromJson(<String, dynamic>{
      'user': 0,
      'package': 'com.game',
      'profile': <String, dynamic>{'touch': 99, 'gpu': -4},
    });
    expect(profile.touchMode, 3);
    expect(profile.gpuMode, 0);
  });
}
