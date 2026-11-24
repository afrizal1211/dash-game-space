import 'package:flutter/material.dart';

import '../bridge/dash_bridge.dart';
import '../data/backup.dart';
import '../theme.dart';
import '../widgets/game_backdrop.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  void _info(BuildContext context, String title, String body) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _export(BuildContext context) async {
    final String json = const GameSpaceBackup().encode();
    _info(context, 'Game Space backup', json);
  }

  Future<void> _import(BuildContext context) async {
    final BridgeResult token =
        await DashBridge.instance.send('GET game.confirm import');
    if (!token.ok || token.result == null) {
      if (context.mounted) {
        _info(context, 'Import failed', token.error ?? 'Dash unavailable');
      }
      return;
    }
    final BridgeResult reply = await DashBridge.instance
        .send(GameSpaceBackup.importCommand(token.result!));
    if (context.mounted) {
      _info(context, 'Import Dash backup', reply.ok ? 'Imported' : (reply.error ?? 'Failed'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Tools')),
      body: GameBackdrop(
        child: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Appearance'),
            onTap: () => _info(
              context,
              'Appearance',
              'Theme and card density settings live in Dash Game Space.',
            ),
          ),
          ListTile(
            title: const Text('Language'),
            onTap: () => _info(context, 'Language', 'English is currently active.'),
          ),
          ListTile(
            title: const Text('Permissions'),
            onTap: () => _info(
              context,
              'Permissions',
              'The Dash bridge requires both apps to share a signing key.',
            ),
          ),
          ListTile(
            title: const Text('Data'),
            onTap: () => _info(
              context,
              'Data',
              'Game list, profiles and widget layout are stored locally.',
            ),
          ),
          ListTile(
            title: const Text('Export Game Space backup'),
            onTap: () => _export(context),
          ),
          ListTile(
            title: const Text('Import Dash backup'),
            onTap: () => _import(context),
          ),
        ],
      ),
      ),
    );
  }
}
