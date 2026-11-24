import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class MusicState {
  const MusicState({this.track, this.playing = false});

  final String? track;
  final bool playing;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'track': track,
        'playing': playing,
      };

  static MusicState fromJson(Map<String, dynamic> raw) {
    return MusicState(
      track: raw['track']?.toString(),
      playing: raw['playing'] == true,
    );
  }

  static MusicState decode(String raw) {
    final Object? decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return const MusicState();
    return fromJson(decoded);
  }

  String encode() => jsonEncode(toJson());

  @override
  bool operator ==(Object other) =>
      other is MusicState && other.track == track && other.playing == playing;

  @override
  int get hashCode => Object.hash(track, playing);
}
