import 'package:chatgpt_clone/pages/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Expanded(child: Text('Chat History')),
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
