import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class GameProfile {
  const GameProfile({
    required this.package,
    this.user = 0,
    this.cpuMode = 0,
    this.gpuMode = 0,
    this.touchMode = 0,
  });

  final String package;
  final int user;
  final int cpuMode;
  final int gpuMode;
  final int touchMode;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user,
        'package': package,
        'profile': <String, dynamic>{
          'touch': touchMode.clamp(0, 3),
          'gpu': gpuMode.clamp(0, 3),
        },
      };

  static GameProfile fromJson(Map<String, dynamic> raw) {
    final Map<String, dynamic> profile = raw['profile'] is Map
        ? Map<String, dynamic>.from(raw['profile'] as Map)
        : <String, dynamic>{};
    final Object? cpuRaw = profile['cpu'];
    int cpuMode = 0;
    if (cpuRaw is num) {
      cpuMode = cpuRaw.toInt();
    } else if (cpuRaw is Map && cpuRaw['mode'] is num) {
      cpuMode = (cpuRaw['mode'] as num).toInt();
    }
    return GameProfile(
      package: raw['package']?.toString() ?? '',
      user: (raw['user'] as num?)?.toInt() ?? 0,
      touchMode: ((profile['touch'] as num?)?.toInt() ?? 0).clamp(0, 3),
      gpuMode: ((profile['gpu'] as num?)?.toInt() ?? 0).clamp(0, 3),
      cpuMode: cpuMode.clamp(0, 9),
    );
  }

  String encode() => jsonEncode(toJson());

  @override
  bool operator ==(Object other) =>
      other is GameProfile &&
      other.package == package &&
      other.user == user &&
      other.cpuMode == cpuMode &&
      other.gpuMode == gpuMode &&
      other.touchMode == touchMode;

  @override
  int get hashCode => Object.hash(package, user, cpuMode, gpuMode, touchMode);
}
