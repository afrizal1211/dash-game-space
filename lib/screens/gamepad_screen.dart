import 'package:flutter/material.dart';

class GamepadScreen extends StatefulWidget {
  const GamepadScreen({super.key});

  @override
  State<GamepadScreen> createState() => _GamepadScreenState();
}

class _GamepadScreenState extends State<GamepadScreen> {
  String _device = 'No gamepad detected';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gamepad')),
      body: Center(
        child: Text(_device),
      ),
    );
  }
}
