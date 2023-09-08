import 'package:chatgpt_clone/services/chatgpt/chatgpt_chat_client.dart';
import 'package:flutter/cupertino.dart';

class ChatGPTModel with ChangeNotifier {
  late ChatGPTChatClient _chatGPTChatClient;
  bool clientInitialized = false;
  String response = '';

  ChatGPTModel({String? apiKey}) {
    _init(apiKey);
  }

  set _initialized(bool isApiKeySet) {
    clientInitialized = isApiKeySet;
    notifyListeners();
  }

  void _init(String? apiKey) {
    if (apiKey != null) {
      _chatGPTChatClient = ChatGPTChatClient(apiKey);
      _initialized = true;
    } else {
      _chatGPTChatClient = ChatGPTChatClient('');
      _initialized = false;
    }
  }

  ChatGPTModel updateApiKey(String? apiKey) {
    _init(apiKey);
    return this;
  }

  Future<void> executePrompt(String prompt) {
    response = '';
    return _chatGPTChatClient.executePrompt(prompt).forEach((element) {
      response += element.delta;
      notifyListeners();
    });
  }
}
