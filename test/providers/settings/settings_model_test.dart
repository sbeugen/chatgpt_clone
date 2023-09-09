import 'package:chatgpt_clone/providers/settings/settings_model.dart';
import 'package:chatgpt_clone/services/chatgpt/openai_api_key_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_callback_function.dart';
import 'settings_model_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OpenAIApiKeyService>()])
void main() {
  final notifyListenerCallback = MockCallbackFunction();

  setUp(() {
    reset(notifyListenerCallback);
  });

  test('initialized is false if not waited for Future', () {
    final mockOpenAIApiKeyService = MockOpenAIApiKeyService();
    when(mockOpenAIApiKeyService.provideApiKey())
        .thenAnswer((realInvocation) => Future.value(null));

    final settingsModel =
        SettingsModel(openAIApiKeyService: mockOpenAIApiKeyService)
          ..addListener(notifyListenerCallback);

    expect(settingsModel.initialized, false);
    expect(settingsModel.openAIApiKey, null);
    verifyZeroInteractions(notifyListenerCallback);
  });

  test(
      'openAIApiKey should be null and initialized true if OpenAIApiKeyService returns null',
      () async {
    final mockOpenAIApiKeyService = MockOpenAIApiKeyService();
    when(mockOpenAIApiKeyService.provideApiKey())
        .thenAnswer((realInvocation) => Future.value(null));

    final settingsModel =
        SettingsModel(openAIApiKeyService: mockOpenAIApiKeyService)
          ..addListener(notifyListenerCallback);
    await Future.delayed(Duration.zero);

    expect(settingsModel.initialized, true);
    expect(settingsModel.openAIApiKey, null);
    verify(notifyListenerCallback()).called(1);
  });

  test('openAIApiKey should be value provided by OpenAIApiKeyService',
      () async {
    final mockOpenAIApiKeyService = MockOpenAIApiKeyService();
    when(mockOpenAIApiKeyService.provideApiKey())
        .thenAnswer((realInvocation) => Future.value('apiKey'));

    final settingsModel =
        SettingsModel(openAIApiKeyService: mockOpenAIApiKeyService)
          ..addListener(notifyListenerCallback);
    await Future.delayed(Duration.zero);

    expect(settingsModel.initialized, true);
    expect(settingsModel.openAIApiKey, 'apiKey');
    verify(notifyListenerCallback()).called(1);
  });

  group('updateOpenAIApiKey', () {
    test('should set apiKey and call storeApiKey if not empty string',
        () async {
      final mockOpenAIApiKeyService = MockOpenAIApiKeyService();
      when(mockOpenAIApiKeyService.provideApiKey())
          .thenAnswer((realInvocation) => Future.value(null));

      final settingsModel =
          SettingsModel(openAIApiKeyService: mockOpenAIApiKeyService)
            ..addListener(notifyListenerCallback);
      await Future.delayed(Duration.zero);

      settingsModel.updateOpenAIApiKey('apiKey');

      expect(settingsModel.openAIApiKey, 'apiKey');
      expect(settingsModel.initialized, true);
      verify(mockOpenAIApiKeyService.storeApiKey('apiKey')).called(1);
      verify(notifyListenerCallback()).called(2);
    });

    test('should set empty apiKey and call deleteApiKey if empty string',
        () async {
      final mockOpenAIApiKeyService = MockOpenAIApiKeyService();
      when(mockOpenAIApiKeyService.provideApiKey())
          .thenAnswer((realInvocation) => Future.value(null));

      final settingsModel =
          SettingsModel(openAIApiKeyService: mockOpenAIApiKeyService)
            ..addListener(notifyListenerCallback);
      await Future.delayed(Duration.zero);

      settingsModel.updateOpenAIApiKey('');

      expect(settingsModel.openAIApiKey, '');
      expect(settingsModel.initialized, true);
      verify(mockOpenAIApiKeyService.deleteApiKey()).called(1);
      verify(notifyListenerCallback()).called(2);
    });
  });
}
