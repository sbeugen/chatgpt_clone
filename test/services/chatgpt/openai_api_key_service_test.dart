import 'package:chatgpt_clone/services/chatgpt/openai_api_key_service.dart';
import 'package:chatgpt_clone/services/storage/key_value_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'openai_api_key_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<KeyValueStorageService>()])
void main() {
  test('should return api key', () async {
    final mockKeyValueStorageService = MockKeyValueStorageService();
    when(mockKeyValueStorageService
            .read(OpenAIApiKeyService.apiKeyStorageKeyName))
        .thenAnswer((_) => Future.value('api_key'));

    final result = await OpenAIApiKeyService(
            keyValueStorageService: mockKeyValueStorageService)
        .provideApiKey();

    expect(result, equals('api_key'));
  });

  test('should store api key', () {
    final mockKeyValueStorageService = MockKeyValueStorageService();
    OpenAIApiKeyService(keyValueStorageService: mockKeyValueStorageService)
        .storeApiKey('apiKey');

    verify(mockKeyValueStorageService.write(
        OpenAIApiKeyService.apiKeyStorageKeyName, 'apiKey'));
  });

  test('should delete api key', () {
    final mockKeyValueStorageService = MockKeyValueStorageService();
    OpenAIApiKeyService(keyValueStorageService: mockKeyValueStorageService)
        .deleteApiKey();

    verify(mockKeyValueStorageService
        .delete(OpenAIApiKeyService.apiKeyStorageKeyName));
  });
}
