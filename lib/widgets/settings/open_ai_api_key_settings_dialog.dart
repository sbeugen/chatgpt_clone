import 'package:flutter/material.dart';

Future<String?> showOpenAIApiKeySettingsDialog(
    BuildContext context, String apiKey) async {
  void saveValue(String value) {
    Navigator.of(context).pop(value);
  }

  final controller = TextEditingController(text: apiKey);

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter OpenAI API key'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'API key'),
          controller: controller,
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('SAVE'),
            onPressed: () {
              saveValue(controller.text);
            },
          ),
        ],
      );
    },
  );
}
