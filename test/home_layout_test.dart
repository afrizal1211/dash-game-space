import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dash_game_space/screens/home_screen.dart';

void main() {
  testWidgets('home shows four cards on a wide Explore surface', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.byKey(const Key('home-card-row')), findsOneWidget);
    expect(find.byType(GlassCard), findsNWidgets(4));
    expect(find.byKey(const Key('mode-content-Explore')), findsOneWidget);
  });

  testWidgets('mode tabs switch content', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.byKey(const Key('mode-content-Explore')), findsOneWidget);

    await tester.tap(find.text('Handheld'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('mode-content-Handheld')), findsOneWidget);
    expect(find.byKey(const Key('mode-content-Explore')), findsNothing);

    await tester.tap(find.text('Gamepad'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('mode-content-Gamepad')), findsOneWidget);
  });

  testWidgets('home cards use distinct icons', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.byIcon(Icons.sports_esports_rounded), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
    expect(find.byIcon(Icons.speed_rounded), findsOneWidget);
    expect(find.byIcon(Icons.build_rounded), findsOneWidget);
  });
}
