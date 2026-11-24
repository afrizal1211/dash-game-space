import 'package:flutter/material.dart';

import '../theme.dart';

class NavCapsule extends StatelessWidget {
  const NavCapsule({
    required this.modes,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<String> modes;
  final String selected;
  final ValueChanged<String> onChanged;

  static const Map<String, IconData> _icons = <String, IconData>{
    'Explore': Icons.explore_rounded,
    'Handheld': Icons.smartphone_rounded,
    'Gamepad': Icons.videogame_asset_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('nav-capsule'),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: GameSpaceTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final String mode in modes)
            Semantics(
              button: true,
              selected: selected == mode,
              child: InkWell(
                onTap: () => onChanged(mode),
                borderRadius: BorderRadius.circular(26),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: selected == mode
                        ? const LinearGradient(
                            colors: <Color>[
                              GameSpaceTheme.accent,
                              GameSpaceTheme.accentDeep,
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        _icons[mode] ?? Icons.circle,
                        size: 17,
                        color: selected == mode
                            ? GameSpaceTheme.ink
                            : GameSpaceTheme.muted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        mode,
                        style: TextStyle(
                          color: selected == mode
                              ? GameSpaceTheme.ink
                              : GameSpaceTheme.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
