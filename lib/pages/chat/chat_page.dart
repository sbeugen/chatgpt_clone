import 'package:chatgpt_clone/providers/chatgpt/chatgpt_model.dart';
import 'package:chatgpt_clone/providers/settings/settings_model.dart';
import 'package:chatgpt_clone/widgets/main_drawer.dart';
import 'package:chatgpt_clone/widgets/missing_open_ai_api_key_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  bool _dialogShown = false;
  bool _sendButtonEnabled = false;
  final _chatInputController = TextEditingController();

  @override
  void dispose() {
    _chatInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatGPTModel = context.watch<ChatGPTModel>();
    final settingModel = context.watch<SettingsModel>();

    final setupComplete = chatGPTModel.clientInitialized;
    final inputFieldHint = setupComplete
        ? 'Write something...'
        : 'Set your API key in the settings';

    if (!setupComplete && !_dialogShown && settingModel.initialized) {
      Future.delayed(Duration.zero, () {
        showMissingOpenAiApiKeyDialog(context);
        setState(() {
          _dialogShown = true;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Chat'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).appBarTheme.toolbarTextStyle?.color,
            ),
            onPressed: () {
              print('plus pressed');
            },
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              children: chatGPTModel.currentChat.messages
                  .map((chatMessage) => Container(
                      color: chatMessage.type == ChatMessageTypes.response &&
                              chatMessage.text.isNotEmpty
                          ? Colors.grey.withAlpha(30)
                          : null,
                      child: Text(chatMessage.text)))
                  .toList(),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: TextField(
                    enabled: setupComplete,
                    decoration: InputDecoration(hintText: inputFieldHint),
                    controller: _chatInputController,
                    onChanged: (value) {
                      setState(() {
                        _sendButtonEnabled = value.isNotEmpty;
                      });
                    },
                  ),
                )),
                IconButton(
                  onPressed: _sendButtonEnabled
                      ? () {
                          chatGPTModel.executePrompt(_chatInputController.text);
                          _chatInputController.clear();
                        }
                      : null,
                  icon: const Icon(
                    Icons.send,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      drawer: const MainDrawer(),
    );
  }
}
