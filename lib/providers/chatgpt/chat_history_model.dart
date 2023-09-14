import 'package:chatgpt_clone/providers/chatgpt/chat_data.dart';
import 'package:flutter/material.dart';

class ChatGPTHistoryModel with ChangeNotifier {
  late Set<Chat> chatHistory = {};

  void updateHistory(Chat chat) {
    chatHistory.add(chat);
    notifyListeners();
  }
}
