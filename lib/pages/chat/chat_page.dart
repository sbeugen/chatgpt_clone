import 'package:chatgpt_clone/providers/chatgpt/chat_data.dart';
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

    void handlePlusActionButtonClick(bool shouldCreateNewChat) {
      if (shouldCreateNewChat) {
        chatGPTModel.startNewChat();
      } else {
        FocusScope.of(context).requestFocus(_chatInputFocusNode);
      }
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
              handlePlusActionButtonClick(hasAtLeastOneMessage);
            },
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: ListView.builder(
                  controller: _chatScrollController,
                  itemCount: chatGPTModel.currentChat.messages.length,
                  itemBuilder: (context, index) {
                    final chatMessage =
                        chatGPTModel.currentChat.messages[index];
                    final isResponse =
                        chatMessage.type == ChatMessageTypes.response;
                    return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        alignment: isResponse
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.85),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isResponse
                                ? Colors.grey[300]
                                : Colors.blue[600],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            chatMessage.text.isEmpty ? '...' : chatMessage.text,
                            style: TextStyle(
                              color: isResponse ? Colors.black : Colors.white,
                            ),
                          ),
                        ));
                  })),
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
