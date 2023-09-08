import 'package:chatgpt_clone/pages/routes.dart';
import 'package:chatgpt_clone/pages/settings/settings_page.dart';
import 'package:go_router/go_router.dart';

import 'chat/chat_page.dart';

final router = GoRouter(initialLocation: Routes.chat.path, routes: [
  GoRoute(
    path: Routes.chat.path,
    builder: (context, state) => const ChatPage(),
  ),
  GoRoute(
      path: Routes.settings.path,
      builder: (context, state) => const SettingsPage())
]);
