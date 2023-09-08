import 'package:chatgpt_clone/widgets/settings/open_ai_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
      ),
      body: const SettingsList(
        sections: [
          OpenAISettingsSection(),
        ],
      ),
    );
  }
}
