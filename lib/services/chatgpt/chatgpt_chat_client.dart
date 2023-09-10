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

  Stream<ChatMessageEvent> executePrompt(
      String prompt, List<ChatGPTHistoryMessage> previousMessages) {
    final chatStream = _createChatStream(prompt, previousMessages);

    return chatStream.map((event) {
      final choice = event.choices.first;
      return ChatMessageEvent(delta: choice.delta.content ?? "");
    });
  }

  Stream<OpenAIStreamChatCompletionModel> _createChatStream(
      String prompt, List<ChatGPTHistoryMessage> previousMessages) {
    return OpenAI.instance.chat.createStream(
        model: _gptModel,
        messages: previousMessages
            .map((e) => OpenAIChatCompletionChoiceMessageModel(
                role: e.role.openAIRole, content: e.content))
            .toList()
          ..add(OpenAIChatCompletionChoiceMessageModel(
              role: OpenAIChatMessageRole.user, content: prompt)));
  }
}

class ChatGPTHistoryMessage {
  final ChatGPTHistoryMessageRoles role;
  final String content;

  const ChatGPTHistoryMessage(this.role, this.content);
}

enum ChatGPTHistoryMessageRoles {
  user(OpenAIChatMessageRole.user),
  assistant(OpenAIChatMessageRole.assistant);

  const ChatGPTHistoryMessageRoles(this.openAIRole);

  final OpenAIChatMessageRole openAIRole;
}
