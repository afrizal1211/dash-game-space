import 'package:flutter/material.dart';

import '../data/game_library.dart';
import 'profile_screen.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  late final Future<List<GameEntry>> _games = GameLibrary().load();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My games')),
      body: FutureBuilder<List<GameEntry>>(
        future: _games,
        builder: (BuildContext context, AsyncSnapshot<List<GameEntry>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No games yet. Add one to begin.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              final GameEntry game = snapshot.data![index];
              return ListTile(
                title: Text(game.label),
                subtitle: Text(game.package),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        ProfileScreen(package: game.package),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
