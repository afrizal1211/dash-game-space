import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dash_game_space/screens/home_screen.dart';

void main() {
  testWidgets('home shows four cards on a wide surface', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.byKey(const Key('home-card-row')), findsOneWidget);
    expect(find.byType(GlassCard), findsNWidgets(4));
  });

  testWidgets('mode labels are distinct', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Handheld'), findsOneWidget);
    expect(find.text('Gamepad'), findsOneWidget);
  });
}
