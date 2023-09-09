import 'package:chatgpt_clone/services/chatgpt/chatgpt_chat_client.dart';
import 'package:flutter/cupertino.dart';

class ChatGPTModel with ChangeNotifier {
  late ChatGPTChatClient? _chatGPTChatClient;
  bool clientInitialized = false;
  String response = '';

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
    response = '';
    return _chatGPTChatClient?.executePrompt(prompt).forEach((element) {
      response += element.delta;
      notifyListeners();
    });
  }
}
