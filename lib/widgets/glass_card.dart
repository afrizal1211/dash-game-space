import 'package:flutter/material.dart';

import '../theme.dart';

class GlassCard extends StatefulWidget {
  const GlassCard({
    required this.child,
    super.key,
    this.onTap,
    this.active = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool active;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      scale: _hovering ? 1.02 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: GameSpaceTheme.panel(active: widget.active || _hovering),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: const Key('glass-card'),
            borderRadius: BorderRadius.circular(24),
            onTap: widget.onTap,
            onHover: (bool value) => setState(() => _hovering = value),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
