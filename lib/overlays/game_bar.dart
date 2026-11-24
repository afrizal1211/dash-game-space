import 'package:flutter/material.dart';

import '../bridge/dash_bridge.dart';

class GameBar extends StatelessWidget {
  const GameBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('game-bar'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: 8,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.speed),
            onPressed: () => DashBridge.instance.send('GET app.fps.light'),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const Scaffold(
                  body: Center(child: Text('Quick settings')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
