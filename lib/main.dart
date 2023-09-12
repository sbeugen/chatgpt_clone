import 'package:chatgpt_clone/pages/router.dart';
import 'package:chatgpt_clone/providers/chatgpt/chatgpt_model.dart';
import 'package:chatgpt_clone/providers/settings/settings_model.dart';
import 'package:chatgpt_clone/services/chatgpt/chatgpt_chat_client.dart';
import 'package:chatgpt_clone/services/chatgpt/openai_api_key_service.dart';
import 'package:chatgpt_clone/services/storage/shared_preferences_key_value_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<SettingsModel>(
          create: (context) => SettingsModel(
              openAIApiKeyService: OpenAIApiKeyService(
                  keyValueStorageService:
                      SharedPreferencesKeyValueStorageService()))),
      ChangeNotifierProxyProvider<SettingsModel, ChatGPTModel>(
          create: (context) => ChatGPTModel(),
          update: (context, settingsModel, chatGPTModel) {
            if (settingsModel.openAIApiKey != null && chatGPTModel != null) {
              return chatGPTModel
                  .updateClient(ChatGPTChatClient(settingsModel.openAIApiKey!));
            }
            return ChatGPTModel();
          }),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.cyanAccent,
          useMaterial3: true),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.cyanAccent,
          useMaterial3: true),
      themeMode: ThemeMode.system,
      title: 'ChatGPT Clone',
    );
  }
}
