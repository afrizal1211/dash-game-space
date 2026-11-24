import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dash_game_space/screens/tune_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('com.nrsqxw.dashgamespace/bridge');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      return '{"ok":false,"error":"ERR: bypass charging is not supported by this kernel"}';
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('tune shows the selected mode and clears snackbars on exit',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TuneScreen()));
    expect(find.byKey(const Key('tune-active-Performance')), findsOneWidget);

    await tester.tap(find.text('Touch boost'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('tune-active-Touch boost')), findsOneWidget);

    await tester.tap(find.text('Bypass charging'));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
  });
}
