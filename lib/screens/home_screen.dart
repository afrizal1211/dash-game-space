import 'package:flutter/material.dart';

import '../widgets/glass_card.dart';
import '../widgets/nav_capsule.dart';

export '../widgets/glass_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
                  final int columns = constraints.maxWidth >= 900 ? 4 : 2;
                  return GridView.count(
                    key: const Key('home-card-row'),
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: <Widget>[
                      for (final String title in <String>[
                        'Game profile',
                        'Tune',
                        'Performance',
                        'Tools',
                      ])
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.sports_esports_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                title,
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
