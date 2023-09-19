// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat()
  ..messages = (json['messages'] as List<dynamic>)
      .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'messages': instance.messages,
    };

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      $enumDecode(_$ChatMessageTypesEnumMap, json['type']),
    )..text = json['text'] as String;

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'type': _$ChatMessageTypesEnumMap[instance.type]!,
      'text': instance.text,
    };

const _$ChatMessageTypesEnumMap = {
  ChatMessageTypes.request: 'request',
  ChatMessageTypes.response: 'response',
};
