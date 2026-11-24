import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dash_game_space/screens/widgets_screen.dart';

void main() {
  testWidgets('widget library shows twelve groups', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WidgetsScreen()));
    expect(find.byKey(const Key('widget-groups')), findsOneWidget);
    for (final String group in widgetGroups) {
      expect(find.text(group), findsOneWidget);
    }
  });

  testWidgets('unavailable readings are labelled', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WidgetsScreen()));
    expect(find.text('unavailable'), findsWidgets);
  });
}
