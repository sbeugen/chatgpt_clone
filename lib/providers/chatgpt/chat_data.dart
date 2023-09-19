import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_data.g.dart';

@JsonSerializable(ignoreUnannotated: true)
class Chat {
  String id = const Uuid().v4();
  @JsonKey(name: 'messages')
  List<ChatMessage> messages = [];

  Chat();

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

  factory Chat.fromMap(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toMap() => _$ChatToJson(this);
}

@JsonSerializable()
class ChatMessage {
  final ChatMessageTypes type;
  String text = '';

  ChatMessage(this.type);

  void appendToText(String textPart) {
    text += textPart;
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

enum ChatMessageTypes {
  request('request'),
  response('response');

  const ChatMessageTypes(this.name);

  final String name;
}
