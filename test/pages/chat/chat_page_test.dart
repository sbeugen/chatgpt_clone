import 'package:chatgpt_clone/pages/chat/chat_page.dart';
import 'package:chatgpt_clone/providers/chatgpt/chatgpt_model.dart';
import 'package:chatgpt_clone/providers/settings/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'chat_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ChatGPTModel>(), MockSpec<SettingsModel>()])
void main() {
  group('missing api key dialog', () {
    testWidgets('should appear if api key is not set', (tester) async {
      final mockChatGPTModel = MockChatGPTModel();
      when(mockChatGPTModel.currentChat).thenReturn(Chat());

      final mockSettingsModel = MockSettingsModel();
      when(mockSettingsModel.initialized).thenReturn(true);

      await tester
          .pumpWidget(createWidget(mockSettingsModel, mockChatGPTModel));
      await tester.pumpAndSettle();

      expect(find.text('No OpenAI API key set'), findsOneWidget);
    });

    testWidgets('should not appear if api key is set/client is initialized', (tester) async {
      final mockChatGPTModel = MockChatGPTModel();
      when(mockChatGPTModel.clientInitialized).thenReturn(true);
      when(mockChatGPTModel.currentChat).thenReturn(Chat());

      final mockSettingsModel = MockSettingsModel();
      when(mockSettingsModel.initialized).thenReturn(true);

      await tester
          .pumpWidget(createWidget(mockSettingsModel, mockChatGPTModel));
      await tester.pumpAndSettle();

      expect(find.text('No OpenAI API key set'), findsNothing);
    });
  });
}

Widget createWidget(SettingsModel settingsModel, ChatGPTModel chatGPTModel) =>
    MaterialApp(
        home: MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsModel>(create: (_) => settingsModel),
        ChangeNotifierProvider<ChatGPTModel>(create: (_) => chatGPTModel),
      ],
      child: const ChatPage(),
    ));
