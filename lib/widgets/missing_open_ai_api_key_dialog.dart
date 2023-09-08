import 'package:chatgpt_clone/pages/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showMissingOpenAiApiKeyDialog(BuildContext context) async {
  void closeDialog() {
    Navigator.of(context).pop();
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('No OpenAI API key set'),
        content: const SingleChildScrollView(
          child: Text('You can set the API key in the settings.'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('LATER'),
            onPressed: () {
              closeDialog();
            },
          ),
          TextButton(
            child: const Text('TO SETTINGS'),
            onPressed: () {
              closeDialog();
              context.push(Routes.settings.path);
            },
          ),
        ],
      );
    },
  );
}
