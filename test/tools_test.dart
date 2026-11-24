import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dash_game_space/screens/tools_screen.dart';

void main() {
  testWidgets('tools screen has correct title and items open dialogs',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToolsScreen()));
    expect(find.text('Tools'), findsWidgets);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Import Dash backup'), findsOneWidget);

    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
  });
}
