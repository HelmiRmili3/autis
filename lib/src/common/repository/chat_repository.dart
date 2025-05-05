import '../../../core/errors/failures.dart';
import '../../../core/types/either.dart';
import '../entitys/chat_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, ChatEntity>> sendMessage(
    String chatId,
    String message,
  );
  Future<void> receiveMessage();
  Future<void> deleteMessage(String messageId);
  Future<Either<Failure, ChatEntity?>> getChat(String patientId);
  Future<Either<Failure, ChatEntity>> startConversation(String userId);
}
