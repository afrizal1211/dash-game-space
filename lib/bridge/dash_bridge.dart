import 'dart:convert';

import 'package:flutter/services.dart';

class BridgeResult {
  const BridgeResult({
    required this.ok,
    this.result,
    this.error,
  });

  final bool ok;
  final String? result;
  final String? error;
}

/// Talks to Dash Essential through its signature-protected ordered broadcast.
class DashBridge {
  DashBridge._();

  static final DashBridge instance = DashBridge._();
  static const MethodChannel _channel =
      MethodChannel('com.nrsqxw.dashgamespace/bridge');

  Future<BridgeResult> send(String command) async {
    try {
      final String raw = await _channel.invokeMethod<String>('send', command) ?? '';
      if (raw.isEmpty || raw == '{}') {
        return const BridgeResult(ok: false, error: 'Dash unavailable');
      }
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return const BridgeResult(ok: false, error: 'invalid bridge reply');
      }
      return BridgeResult(
        ok: decoded['ok'] == true,
        result: decoded['result']?.toString(),
        error: decoded['error']?.toString(),
      );
    } catch (error) {
      return BridgeResult(ok: false, error: '$error');
    }
  }

  Future<Set<String>> capabilities() async {
    final BridgeResult reply = await send('GET app.capabilities');
    if (!reply.ok || reply.result == null) return <String>{};
    try {
      final Object? decoded = jsonDecode(reply.result!);
      if (decoded is! Map<String, dynamic>) return <String>{};
      return decoded.keys.toSet();
    } catch (_) {
      // A malformed capability list is treated as no capabilities.
    }
    return <String>{};
  }
}
