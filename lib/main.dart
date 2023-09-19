import 'package:chatgpt_clone/pages/router.dart';
import 'package:chatgpt_clone/providers/chatgpt/chat_history_model.dart';
import 'package:chatgpt_clone/providers/chatgpt/chatgpt_model.dart';
import 'package:chatgpt_clone/providers/settings/settings_model.dart';
import 'package:chatgpt_clone/services/chatgpt/chatgpt_chat_client.dart';
import 'package:chatgpt_clone/services/chatgpt/openai_api_key_service.dart';
import 'package:chatgpt_clone/services/persistence/history/chatgpt_history_repository.dart';
import 'package:chatgpt_clone/services/persistence/shared_preferences_key_value_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  final chatGPTHistoryRepository = await ChatGPTHistoryRepository.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<SettingsModel>(
          create: (context) => SettingsModel(
              openAIApiKeyService: OpenAIApiKeyService(
                  keyValueStorageService:
                      SharedPreferencesKeyValueStorageRepository()))),
      ChangeNotifierProxyProvider<SettingsModel, ChatGPTModel>(
          create: (context) => ChatGPTModel(),
          update: (context, settingsModel, chatGPTModel) {
            if (chatGPTModel == null) {
              return ChatGPTModel();
            }

            if (settingsModel.openAIApiKey != null) {
              return chatGPTModel
                ..updateClient(settingsModel.openAIApiKey!.isNotEmpty
                    ? ChatGPTChatClient(settingsModel.openAIApiKey!)
                    : null);
            }

            return chatGPTModel;
          }),
      ChangeNotifierProxyProvider<ChatGPTModel, ChatGPTHistoryModel>(
          lazy: false,
          create: (context) => ChatGPTHistoryModel(
              chatGPTHistoryRepository: chatGPTHistoryRepository),
          update: (context, chatGPTModel, chatGPTHistoryModel) {
            if (chatGPTHistoryModel == null) {
              return ChatGPTHistoryModel(
                  chatGPTHistoryRepository: chatGPTHistoryRepository);
            }

            if (chatGPTModel.currentChat.messages.isNotEmpty) {
              return chatGPTHistoryModel
                ..updateHistory(chatGPTModel.currentChat);
            }

            return chatGPTHistoryModel;
          })
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
