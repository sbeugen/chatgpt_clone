import 'package:chatgpt_clone/services/chatgpt/chatgpt_chat_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class ChatGPTModel with ChangeNotifier {
  late ChatGPTChatClient? _chatGPTChatClient;
  bool clientInitialized = false;
  Chat currentChat = Chat();

  ChatGPTModel({ChatGPTChatClient? chatGPTChatClient}) {
    _init(chatGPTChatClient);
  }

  set _initialized(bool isClientSet) {
    clientInitialized = isClientSet;
    notifyListeners();
  }

  void _init(ChatGPTChatClient? chatGPTChatClient) {
    _chatGPTChatClient = chatGPTChatClient;
    _initialized = _chatGPTChatClient != null;
  }

  ChatGPTModel updateClient(ChatGPTChatClient? chatGPTChatClient) {
    return this.._init(chatGPTChatClient);
  }

  Future<void>? executePrompt(String prompt) {
    final previousMessages = currentChat.messages
        .map((message) => ChatGPTHistoryMessage(
            messageTypeToRole(message.type), message.text))
        .toList();

    currentChat.addNewMessage(
        ChatMessage(ChatMessageTypes.request)..appendToText(prompt));
    currentChat.addNewMessage(ChatMessage(ChatMessageTypes.response));

    notifyListeners();

    final responseMessage = currentChat.lastMessage()!;

    return _chatGPTChatClient
        ?.executePrompt(prompt, previousMessages)
        .forEach((element) {
      responseMessage.appendToText(element.delta);
      notifyListeners();
    });
  }
}

class Chat {
  final Uuid id = const Uuid();
  final List<ChatMessage> messages = [];

  void addNewMessage(ChatMessage message) {
    messages.add(message);
  }

  ChatMessage? lastMessage() {
    try {
      return messages.last;
    } catch (_) {
      return null;
    }
  }
}

class ChatMessage {
  final ChatMessageTypes type;
  String text = '';

  ChatMessage(this.type);

  void appendToText(String textPart) {
    text += textPart;
  }
}

enum ChatMessageTypes {
  request('request'),
  response('response');

  const ChatMessageTypes(this.name);

  final String name;
}

ChatGPTHistoryMessageRoles messageTypeToRole(ChatMessageTypes type) {
  switch (type) {
    case ChatMessageTypes.request:
      return ChatGPTHistoryMessageRoles.user;
    case ChatMessageTypes.response:
      return ChatGPTHistoryMessageRoles.assistant;
  }
}
