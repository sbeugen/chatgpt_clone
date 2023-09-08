import 'package:chatgpt_clone/providers/settings/settings_model.dart';
import 'package:chatgpt_clone/widgets/settings/open_ai_api_key_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class OpenAISettingsSection extends AbstractSettingsSection {
  const OpenAISettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsModel = context.watch<SettingsModel>();
    final apiKey = settingsModel.openAIApiKey ?? '';

    final apiKeyDisplayValue = apiKey.length > 4
        ? '****${apiKey.substring(apiKey.length - 4)}'
        : 'Not set';

    Future<void> openApiKeyDialog() async {
      final newApiKey = await showOpenAIApiKeySettingsDialog(context, apiKey);
      if (newApiKey != null && newApiKey != apiKey) {
        settingsModel.updateOpenAIApiKey(newApiKey);
      }
    }

    return SettingsSection(
      title: const Text('OpenAI'),
      tiles: <SettingsTile>[
        SettingsTile.navigation(
          leading: const Icon(Icons.key),
          title: const Text('API Key'),
          value: Text(apiKeyDisplayValue),
          onPressed: (_) {
            openApiKeyDialog();
          },
        ),
      ],
    );
  }
}
