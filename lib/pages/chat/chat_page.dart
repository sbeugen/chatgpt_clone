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
  String lastMessageText = "";
  final _chatInputController = TextEditingController();
  final _chatInputFocusNode = FocusNode();
  final _chatScrollController = ScrollController();

  @override
  void dispose() {
    _chatInputController.dispose();
    super.dispose();
  }

  void _handlePlusActionButtonClick(bool shouldCreateNewChat) {
    if (shouldCreateNewChat) {
      print('create new chat');
    } else {
      FocusScope.of(context).requestFocus(_chatInputFocusNode);
    }
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

    final currentMessageText =
        chatGPTModel.currentChat.lastMessage()?.text ?? "";
    final isCurrentlyPrinting = lastMessageText != currentMessageText;

    if (isCurrentlyPrinting && _chatScrollController.positions.isNotEmpty) {
      lastMessageText = currentMessageText;

      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(microseconds: 100),
        curve: Curves.fastOutSlowIn,
      );
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
              final hasAtLeastOneMessage =
                  chatGPTModel.currentChat.messages.isNotEmpty;
              _handlePlusActionButtonClick(hasAtLeastOneMessage);
            },
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              controller: _chatScrollController,
              children: chatGPTModel.currentChat.messages.map((chatMessage) {
                final isResponse =
                    chatMessage.type == ChatMessageTypes.response;
                return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    color: isResponse
                        ? Colors.white.withAlpha(70)
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isResponse ? 'Response:' : 'Request:',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(chatMessage.text)
                      ],
                    ));
              }).toList(),
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
                    focusNode: _chatInputFocusNode,
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
