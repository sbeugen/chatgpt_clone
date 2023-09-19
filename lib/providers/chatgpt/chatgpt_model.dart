import 'package:chatgpt_clone/providers/chatgpt/chat_data.dart';
import 'package:chatgpt_clone/services/chatgpt/chatgpt_chat_client.dart';
import 'package:flutter/cupertino.dart';

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
    _initialized = chatGPTChatClient != null;
  }

  void updateClient(ChatGPTChatClient? chatGPTChatClient) {
    _init(chatGPTChatClient);
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

  void startNewChat() {
    currentChat = Chat();
    notifyListeners();
  }

  void setCurrentChat(Chat chat) {
    currentChat = chat;
    notifyListeners();
  }
}

ChatGPTHistoryMessageRoles messageTypeToRole(ChatMessageTypes type) {
  switch (type) {
    case ChatMessageTypes.request:
      return ChatGPTHistoryMessageRoles.user;
    case ChatMessageTypes.response:
      return ChatGPTHistoryMessageRoles.assistant;
  }
}
