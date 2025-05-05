import 'package:autis/src/common/entitys/chat_entity.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final ChatEntity? chat;

  ChatLoaded(this.chat);
}

class MessageSent extends ChatState {
  final ChatEntity chat;

  MessageSent(this.chat);
}

class ChatFailure extends ChatState {
  final String error;

  ChatFailure(this.error);
}
