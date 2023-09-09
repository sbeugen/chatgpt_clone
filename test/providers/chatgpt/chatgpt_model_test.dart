import 'package:chatgpt_clone/providers/chatgpt/chatgpt_model.dart';
import 'package:chatgpt_clone/services/chatgpt/chatgpt_chat_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_callback_function.dart';
import 'chatgpt_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ChatGPTChatClient>()])
void main() {
  final notifyListenerCallback = MockCallbackFunction();

  setUp(() {
    reset(notifyListenerCallback);
  });

  group('clientInitialized', () {
    test('is false if no client was provided', () {
      final chatGPTModel = ChatGPTModel();
      expect(chatGPTModel.clientInitialized, false);
    });

    test('is false on updateClient with null as client', () {
      final chatGPTModel = ChatGPTModel()..addListener(notifyListenerCallback);
      chatGPTModel.updateClient(null);

      expect(chatGPTModel.clientInitialized, false);
      verify(notifyListenerCallback()).called(1);
    });

    test('is true if client was provided', () {
      final chatGPTModel =
          ChatGPTModel(chatGPTChatClient: MockChatGPTChatClient());
      expect(chatGPTModel.clientInitialized, true);
    });

    test('is true on updateClient with client', () {
      final chatGPTModel = ChatGPTModel()..addListener(notifyListenerCallback);
      chatGPTModel.updateClient(MockChatGPTChatClient());

      expect(chatGPTModel.clientInitialized, true);
      verify(notifyListenerCallback()).called(1);
    });
  });
}
