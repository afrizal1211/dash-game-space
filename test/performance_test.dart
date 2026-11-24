import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dash_game_space/screens/performance_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('com.nrsqxw.dashgamespace/bridge');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('performance screen has correct title and enabled cards',
      (tester) async {
    final List<MethodCall> calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      calls.add(call);
      return '{"ok":true,"result":"ok"}';
    });

    await tester.pumpWidget(const MaterialApp(
      home: PerformanceScreen(
        capabilities: <String>{'touch', 'perf', 'gpu', 'cpu'},
      ),
    ));

    expect(find.text('Performance'), findsWidgets);
    expect(find.byKey(const Key('widget-enabled-Performance mode')), findsOneWidget);

    await tester.tap(find.byKey(const Key('widget-enabled-Performance mode')));
    await tester.pumpAndSettle();
    expect(calls.map((MethodCall call) => call.arguments), contains('SET perf 1'));
  });

  testWidgets('performance cards are disabled without Dash capabilities',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: PerformanceScreen(capabilities: <String>{}),
    ));
    expect(find.text('unavailable'), findsWidgets);
  });
}
