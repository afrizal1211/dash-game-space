import 'package:flutter/material.dart';

class Crosshair extends StatelessWidget {
  const Crosshair({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: Center(
        child: Icon(Icons.add, color: Colors.red, size: 28),
      ),
    );
  }
}
