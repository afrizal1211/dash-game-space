import 'package:flutter/material.dart';

import 'games_screen.dart';
import 'performance_screen.dart';
import 'tools_screen.dart';
import 'tune_screen.dart';
import '../theme.dart';
import '../widgets/game_backdrop.dart';
import '../widgets/glass_card.dart';
import '../widgets/nav_capsule.dart';

export '../widgets/glass_card.dart';

class _CardSpec {
  const _CardSpec({
    required this.label,
    required this.icon,
    required this.screen,
  });

  final String label;
  final IconData icon;
  final Widget screen;
}

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

  List<_CardSpec> _cards() {
    switch (_mode) {
      case 'Handheld':
        return <_CardSpec>[
          const _CardSpec(
            label: 'Game profile',
            icon: Icons.sports_esports_rounded,
            screen: GamesScreen(),
          ),
          const _CardSpec(
            label: 'Tune',
            icon: Icons.tune_rounded,
            screen: TuneScreen(),
          ),
        ];
      case 'Gamepad':
        return <_CardSpec>[
          _CardSpec(
            label: 'Performance',
            icon: Icons.speed_rounded,
            screen: PerformanceScreen(capabilities: widget.capabilities),
          ),
          const _CardSpec(
            label: 'Tools',
            icon: Icons.build_rounded,
            screen: ToolsScreen(),
          ),
        ];
      default:
        return <_CardSpec>[
          const _CardSpec(
            label: 'Game profile',
            icon: Icons.sports_esports_rounded,
            screen: GamesScreen(),
          ),
          const _CardSpec(
            label: 'Tune',
            icon: Icons.tune_rounded,
            screen: TuneScreen(),
          ),
          _CardSpec(
            label: 'Performance',
            icon: Icons.speed_rounded,
            screen: PerformanceScreen(capabilities: widget.capabilities),
          ),
          const _CardSpec(
            label: 'Tools',
            icon: Icons.build_rounded,
            screen: ToolsScreen(),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<_CardSpec> cards = _cards();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GameBackdrop(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'GAME SPACE  /  DASH',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 2,
                          color: GameSpaceTheme.accent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Play your best',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
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
                  return KeyedSubtree(
                    key: Key('mode-content-$_mode'),
                    child: GridView.count(
                      key: const Key('home-card-row'),
                      crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: <Widget>[
                      for (final _CardSpec card in cards)
                        GlassCard(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => card.screen,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                card.icon,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                card.label,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
