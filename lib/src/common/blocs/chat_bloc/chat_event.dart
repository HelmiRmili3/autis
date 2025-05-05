abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  final String chatId;
  final String message;

  SendMessage(
    this.chatId,
    this.message,
  );
}

class GetChat extends ChatEvent {
  final String patientId;
  GetChat(this.patientId);
}

class CreateConversation extends ChatEvent {
  final String userId;
  CreateConversation(
    this.userId,
  );
}
