import 'package:chatgpt_clone/pages/routes.dart';
import 'package:chatgpt_clone/providers/chatgpt/chat_data.dart';
import 'package:chatgpt_clone/providers/chatgpt/chat_history_model.dart';
import 'package:chatgpt_clone/providers/chatgpt/chatgpt_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final chatGPTModel = context.read<ChatGPTModel>();
    final chatGPTHistoryModel = context.watch<ChatGPTHistoryModel>();

    void switchToSelectedChat(Chat chat) {
      // Navigator.of(context).pop();
      chatGPTModel.setCurrentChat(chat);
    }

    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: ListView(
            children: chatGPTHistoryModel.chatHistory
                .map((chatEntry) => TextButton(
                      key: Key(chatEntry.id),
                      onPressed: () => switchToSelectedChat(chatEntry),
                      child: Text(chatEntry.id),
                    ))
                .toList(),
          )),
          Container(
            alignment: Alignment.bottomLeft,
            child: Column(
              children: [
                const Divider(
                  color: Colors.grey,
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.push(Routes.settings.path);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.settings),
                            Text(
                              ' Settings',
                              style: TextStyle(fontSize: 22),
                            )
                          ],
                        ))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
