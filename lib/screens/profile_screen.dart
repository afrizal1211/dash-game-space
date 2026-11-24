import 'package:flutter/material.dart';

import '../bridge/dash_bridge.dart';
import '../data/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.package, super.key});

  final String package;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late GameProfile _profile =
      GameProfile(package: widget.package);

  Future<void> _save() async {
    await DashBridge.instance.send(
      'SET app.profile ${widget.package} ${_profile.encode()}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(widget.package, style: const TextStyle(fontSize: 12)),
          _ProfileSlider(
            label: 'CPU mode',
            value: _profile.cpuMode,
            onChanged: (int value) =>
                setState(() => _profile = GameProfile(
                      package: widget.package,
                      cpuMode: value,
                      gpuMode: _profile.gpuMode,
                      touchMode: _profile.touchMode,
                    )),
          ),
          _ProfileSlider(
            label: 'GPU mode',
            value: _profile.gpuMode,
            onChanged: (int value) =>
                setState(() => _profile = GameProfile(
                      package: widget.package,
                      cpuMode: _profile.cpuMode,
                      gpuMode: value,
                      touchMode: _profile.touchMode,
                    )),
          ),
          FilledButton(
            onPressed: _save,
            child: const Text('Apply profile'),
          ),
        ],
      ),
    );
  }
}

class _ProfileSlider extends StatelessWidget {
  const _ProfileSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$label: $value'),
      trailing: Wrap(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => onChanged((value - 1).clamp(0, 9)),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => onChanged((value + 1).clamp(0, 9)),
          ),
        ],
      ),
    );
  }
}
