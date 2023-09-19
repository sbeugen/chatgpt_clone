import 'package:chatgpt_clone/services/persistence/key_value_storage_service.dart';

class OpenAIApiKeyService {
  late KeyValueStorageService _keyValueStorageService;
  static const apiKeyStorageKeyName = 'OPEN_AI_API_KEY';

  OpenAIApiKeyService(
      {required KeyValueStorageService keyValueStorageService}) {
    _keyValueStorageService = keyValueStorageService;
  }

  Future<void> storeApiKey(String apiKey) {
    return _keyValueStorageService.write(apiKeyStorageKeyName, apiKey);
  }

  Future<String?> provideApiKey() async {
    return _keyValueStorageService.read(apiKeyStorageKeyName);
  }

  Future<void> deleteApiKey() {
    return _keyValueStorageService.delete(apiKeyStorageKeyName);
  }
}
