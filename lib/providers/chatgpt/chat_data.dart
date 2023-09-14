import 'package:uuid/uuid.dart';

class Chat {
  final String id = const Uuid().v4();
  final List<ChatMessage> messages = [];

  void addNewMessage(ChatMessage message) {
    messages.add(message);
  }

  ChatMessage? lastMessage() {
    try {
      return messages.last;
    } catch (_) {
      return null;
    }
  }
}

class ChatMessage {
  final ChatMessageTypes type;
  String text = '';

  ChatMessage(this.type);

  void appendToText(String textPart) {
    text += textPart;
  }
}

enum ChatMessageTypes {
  request('request'),
  response('response');

  const ChatMessageTypes(this.name);

  final String name;
}
