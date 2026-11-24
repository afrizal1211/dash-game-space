import 'package:flutter/material.dart';

import '../theme.dart';

class GameBackdrop extends StatelessWidget {
  const GameBackdrop({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.4, -0.7),
              radius: 1.4,
              colors: <Color>[Color(0xFF15264A), GameSpaceTheme.ink],
            ),
          ),
        ),
        Positioned(
          top: -120,
          right: -80,
          child: _Glow(color: GameSpaceTheme.accentDeep, size: 280),
        ),
        Positioned(
          bottom: -140,
          left: -100,
          child: _Glow(
            color: const Color(0xFF7B4DFF),
            size: 320,
          ),
        ),
        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.18),
      ),
    );
  }
}
