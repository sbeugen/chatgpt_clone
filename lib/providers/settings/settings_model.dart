import 'package:chatgpt_clone/services/chatgpt/openai_api_key_service.dart';
import 'package:flutter/cupertino.dart';

class SettingsModel with ChangeNotifier {
  String? openAIApiKey;
  late final OpenAIApiKeyService _openAIApiKeyService;
  bool initialized = false;

  SettingsModel({required OpenAIApiKeyService openAIApiKeyService}) {
    _openAIApiKeyService = openAIApiKeyService;
    _openAIApiKeyService
        .provideApiKey()
        .then((apiKey) => _setOpenAIApiKey(apiKey));
  }

  void _setOpenAIApiKey(String? apiKey) {
    openAIApiKey = apiKey;
    initialized = true;
    notifyListeners();
  }

  void updateOpenAIApiKey(String openAIApiKey) {
    _setOpenAIApiKey(openAIApiKey);
    if (openAIApiKey.isNotEmpty) {
      _openAIApiKeyService.storeApiKey(openAIApiKey);
    } else {
      _openAIApiKeyService.deleteApiKey();
    }
  }
}
