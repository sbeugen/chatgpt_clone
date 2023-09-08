import 'package:dart_openai/dart_openai.dart';

class ChatMessageEvent {
  final String delta;

  const ChatMessageEvent({required this.delta});
}

class ChatGPTChatClient {
  final _gptModel = "gpt-3.5-turbo";

  ChatGPTChatClient(String apiKey) {
    OpenAI.apiKey = apiKey;
  }

  Stream<ChatMessageEvent> executePrompt(String prompt) {
    final chatStream = _createChatStream(prompt);

    return chatStream.map((event) {
      final choice = event.choices.first;
      return ChatMessageEvent(delta: choice.delta.content ?? "");
    });
  }

  Stream<OpenAIStreamChatCompletionModel> _createChatStream(String prompt) {
    return OpenAI.instance.chat.createStream(model: _gptModel, messages: [
      OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user, content: prompt)
    ]);
  }
}
