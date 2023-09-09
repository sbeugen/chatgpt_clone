import 'package:chatgpt_clone/pages/settings/settings_page.dart';
import 'package:chatgpt_clone/providers/settings/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'settings_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SettingsModel>()])
void main() {
  group('OpenAISettingsSection', () {
    testWidgets('should display all elements', (tester) async {
      await tester.pumpWidget(createWidget(MockSettingsModel()));

      expect(find.text('OpenAI'), findsOneWidget);
      expect(find.text('API Key'), findsOneWidget);
      expect(find.text('Not set'), findsOneWidget);
    });

    testWidgets('should display obfuscated API key if set', (tester) async {
      final settingsModel = MockSettingsModel();
      when(settingsModel.openAIApiKey).thenReturn('apiKey');
      await tester.pumpWidget(createWidget(settingsModel));

      expect(find.text('Not set'), findsNothing);
      expect(find.text('****iKey'), findsOneWidget);
    });

    testWidgets('should open dialog when clicking on API Key entry',
        (tester) async {
      await tester.pumpWidget(createWidget(MockSettingsModel()));

      await tester.tap(find.text('API Key'));
      await tester.pumpAndSettle();

      expect(find.text('Enter OpenAI API key'), findsOneWidget);
    });

    testWidgets('should close dialog when clicking CANCEL', (tester) async {
      await tester.pumpWidget(createWidget(MockSettingsModel()));

      await tester.tap(find.text('API Key'));
      await tester.pumpAndSettle();

      expect(find.text('Enter OpenAI API key'), findsOneWidget);

      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();

      expect(find.text('Enter OpenAI API key'), findsNothing);
    });

    testWidgets('should display API key in dialog if set', (tester) async {
      final settingsModel = MockSettingsModel();
      when(settingsModel.openAIApiKey).thenReturn('apiKey');
      await tester.pumpWidget(createWidget(settingsModel));

      await tester.tap(find.text('API Key'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'apiKey'), findsOneWidget);
    });

    testWidgets(
        'should not call settingsModel.updateOpenAIApiKey if API key was not changed',
        (tester) async {
      final settingsModel = MockSettingsModel();
      when(settingsModel.openAIApiKey).thenReturn('apiKey');
      await tester.pumpWidget(createWidget(settingsModel));

      await tester.tap(find.text('API Key'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('SAVE'));

      verifyNever(settingsModel.updateOpenAIApiKey(any));
    });

    testWidgets(
        'should call settingsModel.updateOpenAIApiKey if API key was changed',
        (tester) async {
      final settingsModel = MockSettingsModel();
      when(settingsModel.openAIApiKey).thenReturn('apiKey');
      await tester.pumpWidget(createWidget(settingsModel));

      await tester.tap(find.text('API Key'));
      await tester.pumpAndSettle();

      await tester.enterText(find.text('apiKey'), 'otherKey');

      await tester.tap(find.text('SAVE'));

      verify(settingsModel.updateOpenAIApiKey('otherKey'));
    });
  });
}

Widget createWidget(SettingsModel settingsModel) =>
    ChangeNotifierProvider<SettingsModel>(
      create: (_) => settingsModel,
      child: const MaterialApp(
        home: SettingsPage(),
      ),
    );
