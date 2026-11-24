import 'package:flutter/material.dart';

import '../bridge/dash_bridge.dart';
import '../data/backup.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <Widget>[
          const ListTile(title: Text('Appearance')),
          const ListTile(title: Text('Language')),
          const ListTile(title: Text('Permissions')),
          const ListTile(title: Text('Data')),
          ListTile(
            title: const Text('Export Game Space backup'),
            onTap: () {
              const GameSpaceBackup().encode();
            },
          ),
          ListTile(
            title: const Text('Import Dash backup'),
            onTap: () async {
              final BridgeResult token =
                  await DashBridge.instance.send('GET game.confirm import');
              if (!token.ok || token.result == null) return;
              await DashBridge.instance
                  .send(GameSpaceBackup.importCommand(token.result!));
            },
          ),
        ],
      ),
    );
  }
}
