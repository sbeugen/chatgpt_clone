import 'package:chatgpt_clone/providers/chatgpt/chat_data.dart';
import 'package:chatgpt_clone/services/persistence/history/chatgpt_history_repository.dart';
import 'package:flutter/material.dart';

class ChatGPTHistoryModel with ChangeNotifier {
  final Set<Chat> chatHistory = {};
  final ChatGPTHistoryRepository chatGPTHistoryRepository;

  ChatGPTHistoryModel({required this.chatGPTHistoryRepository}) {
    chatGPTHistoryRepository.getAll().then((history) => {
          for (final chat in history) {chatHistory.add(chat)}
        });
  }

  void updateHistory(Chat chat) {
    chatHistory.add(chat);
    chatGPTHistoryRepository.upsertChat(chat);
    notifyListeners();
  }
}
