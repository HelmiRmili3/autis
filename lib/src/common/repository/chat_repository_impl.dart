import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/repository/chat_repository.dart';

import '../data/chat_remote_data_source.dart';
import '../entitys/chat_entity.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatRemoteDataSource;

  ChatRepositoryImpl(
    this.chatRemoteDataSource,
  );

  @override
  Future<void> deleteMessage(String messageId) {
    return chatRemoteDataSource.deleteMessage(messageId);
  }

  @override
  Future<Either<Failure, ChatEntity?>> getChat(String patientId) {
    return chatRemoteDataSource.getChat(patientId);
  }

  @override
  Future<void> receiveMessage() {
    return chatRemoteDataSource.receiveMessage();
  }

  @override
  Future<Either<Failure, ChatEntity>> sendMessage(
      String chatId, String message) {
    return chatRemoteDataSource.sendMessage(chatId, message);
  }

  @override
  Future<Either<Failure, ChatEntity>> startConversation(String userId) {
    return chatRemoteDataSource.startConversation(userId);
  }
}
