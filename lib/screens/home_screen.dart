import 'package:flutter/material.dart';

import '../screens/games_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/tune_screen.dart';
import '../screens/widgets_screen.dart';
import '../widgets/glass_card.dart';
import '../widgets/nav_capsule.dart';

export '../widgets/glass_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.capabilities = const <String>{},
  });

  final Set<String> capabilities;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _mode = 'Explore';
  static const List<String> _modes = <String>['Explore', 'Handheld', 'Gamepad'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16),
            NavCapsule(
              modes: _modes,
              selected: _mode,
              onChanged: (String mode) => setState(() => _mode = mode),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final int columns = _mode == 'Handheld'
                      ? 2
                      : (constraints.maxWidth >= 900 ? 4 : 2);
                  final Map<String, Widget> routes = <String, Widget>{
                    'Game profile': const GamesScreen(),
                    'Tune': const TuneScreen(),
                    'Performance': const WidgetsScreen(),
                    'Tools': const SettingsScreen(),
                  };
                  return GridView.count(
                    key: const Key('home-card-row'),
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: <Widget>[
                      for (final MapEntry<String, Widget> entry in routes.entries)
                        GlassCard(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => entry.value,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.sports_esports_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
