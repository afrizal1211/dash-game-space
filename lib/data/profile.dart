import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class GameProfile {
  const GameProfile({
    required this.package,
    this.cpuMode = 0,
    this.gpuMode = 0,
    this.touchMode = 0,
  });

  final String package;
  final int cpuMode;
  final int gpuMode;
  final int touchMode;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'package': package,
        'cpuMode': cpuMode,
        'gpuMode': gpuMode,
        'touchMode': touchMode,
      };

  static GameProfile fromJson(Map<String, dynamic> raw) {
    return GameProfile(
      package: raw['package']?.toString() ?? '',
      cpuMode: (raw['cpuMode'] as num?)?.toInt() ?? 0,
      gpuMode: (raw['gpuMode'] as num?)?.toInt() ?? 0,
      touchMode: (raw['touchMode'] as num?)?.toInt() ?? 0,
    );
  }

  String encode() => jsonEncode(toJson());

  static GameProfile decode(String raw) {
    final Object? decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return const GameProfile(package: '');
    return fromJson(decoded);
  }

  @override
  bool operator ==(Object other) =>
      other is GameProfile &&
      other.package == package &&
      other.cpuMode == cpuMode &&
      other.gpuMode == gpuMode &&
      other.touchMode == touchMode;

  @override
  int get hashCode => Object.hash(package, cpuMode, gpuMode, touchMode);
}
