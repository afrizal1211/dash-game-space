import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dash_game_space/bridge/dash_bridge.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('com.nrsqxw.dashgamespace/bridge');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('bridge parses a successful daemon reply', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      expect(call.method, 'send');
      expect(call.arguments, 'GET app.fps.light');
      return '{"ok":true,"result":"{\\"fps\\":60}"}';
    });
    final BridgeResult result =
        await DashBridge.instance.send('GET app.fps.light');
    expect(result.ok, isTrue);
    expect(result.result, contains('fps'));
  });

  test('capabilities are empty when Dash is unavailable', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      return '{}';
    });
    expect(await DashBridge.instance.capabilities(), isEmpty);
  });
}
