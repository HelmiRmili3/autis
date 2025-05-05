import 'package:autis/src/common/entitys/message_entity.dart';

class ChatEntity {
  final String chatId;
  final DateTime lastInteraction;
  final String lastMessage;
  final List<MessageEntity> messages;
  final List<String> participants;

  ChatEntity({
    required this.chatId,
    required this.lastInteraction,
    required this.lastMessage,
    required this.messages,
    required this.participants,
  });

  // factory ChatEntity.fromJson(Map<String, dynamic> json) {
  //   return ChatEntity(
  //     chatId: json['chatId'] as String,
  //     lastInteraction: DateTime.parse(json['lastInteraction'] as String),
  //     lastMessage: json['lastMessage'] as String,
  //     messages: (json['messages'] as List)
  //         .map((item) => MessageEntity.fromJson(item as Map<String, dynamic>))
  //         .toList(),
  //     participants: List<String>.from(json['participants'] as List),
  //   );
  // }
  factory ChatEntity.fromJson(Map<String, dynamic> json) {
    return ChatEntity(
      chatId: json['chatId'].toString(),
      lastInteraction: DateTime.parse(json['lastInteraction'].toString()),
      lastMessage: json['lastMessage'].toString(),
      messages: (json['messages'] as Map<Object?, Object?>?)?.values.map((msg) {
            return MessageEntity.fromJson(
                Map<String, dynamic>.from(msg as Map));
          }).toList() ??
          [],
      participants:
          (json['participants'] as List).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'lastInteraction': lastInteraction.toIso8601String(),
      'lastMessage': lastMessage,
      'messages': messages.map((message) => message.toJson()).toList(),
      'participants': participants,
    };
  }
}
