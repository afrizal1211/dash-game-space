import 'package:flutter_test/flutter_test.dart';
import 'package:dash_game_space/media/music_controller.dart';

void main() {
  test('playlist state starts stopped and restores from JSON', () {
    const MusicState empty = MusicState();
    expect(empty.playing, isFalse);
    expect(empty.track, isNull);

    const MusicState playing = MusicState(
      track: '/storage/song.mp3',
      playing: true,
    );
    expect(MusicState.fromJson(playing.toJson()), playing);
  });
}
