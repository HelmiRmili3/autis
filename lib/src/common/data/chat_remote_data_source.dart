import 'package:autis/core/services/secure_storage_service.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/entitys/chat_entity.dart';
import 'package:autis/src/common/entitys/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../../core/errors/failures.dart';

abstract class ChatRemoteDataSource {
  Future<Either<Failure, ChatEntity>> sendMessage(
      String chatId, String message);
  Future<void> receiveMessage();
  Future<void> deleteMessage(String messageId);
  Future<Either<Failure, ChatEntity?>> getChat(String patientId);
  Future<Either<Failure, ChatEntity>> startConversation(String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;
  final FirebaseFirestore firebaseFirestore;
  final UserProfileStorage userProfile;
  ChatRemoteDataSourceImpl(
    this.firebaseAuth,
    this.firebaseDatabase,
    this.firebaseFirestore,
    this.userProfile,
  );
  @override
  Future<Either<Failure, ChatEntity>> sendMessage(
    String chatId,
    String message,
  ) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        return const Left(FirestoreFailure('No authenticated user'));
      }

      final chatRef = firebaseDatabase.ref('Chats/$chatId');
      final newMessageRef = chatRef.child('messages').push();
      final messageId = newMessageRef.key;
      if (messageId == null) {
        return const Left(FirestoreFailure('Failed to generate a message ID'));
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final messageData = {
        'id': messageId,
        'message': message,
        'senderId': currentUser.uid,
        'timestamp': timestamp,
      };

      await newMessageRef.set(messageData);

      await chatRef.update({
        'lastMessage': message,
        'lastInteraction': DateTime.now().toIso8601String(),
      });

      final chatSnapshot = await chatRef.get();

      if (!chatSnapshot.exists) {
        return const Left(FirestoreFailure('Chat not found'));
      }

      final chatData = Map<String, dynamic>.from(chatSnapshot.value as Map);
      final updatedChat = ChatEntity.fromJson(chatData);
      return Right(updatedChat);
    } catch (e) {
      return Left(FirestoreFailure("Failure sending messgae $e"));
    }
  }

  @override
  Future<Either<Failure, ChatEntity?>> getChat(String patientId) async {
    try {
      // final UserEntity? currentUser = await userProfile.getUserProfile();
      // if (currentUser == null) {
      //   return const Left(FirestoreFailure('No authenticated user'));
      // }

      // 1. Get user's chat list
      final userChatsSnapshot =
          await firebaseDatabase.ref('Users/$patientId/chats').get();
      debugPrint("snapshot  : $userChatsSnapshot");

      if (!userChatsSnapshot.exists) {
        return const Right(null); // The user has no chats
      }

      final chatsMap = Map<String, dynamic>.from(
        userChatsSnapshot.value as Map<Object?, Object?>,
      );
      debugPrint("chatsMap: $chatsMap");

      if (chatsMap.isEmpty) {
        return const Right(null);
      }

      final chatId = chatsMap.keys.first;

      // 2. Fetch the actual chat
      final chatRef = firebaseDatabase.ref('Chats/$chatId');
      final snapshot = await chatRef.get();
      debugPrint("snapshot.value: ${snapshot.value}");

      if (!snapshot.exists) {
        return const Right(null);
      }

      final chatData = Map<String, dynamic>.from(
        snapshot.value as Map<Object?, Object?>,
      );
      debugPrint("chatData: $chatData");

      final chat = ChatEntity.fromJson(chatData);
      debugPrint("Parsed Chat: $chat");

      return Right(chat);
    } on FirebaseException catch (e) {
      debugPrint("Firebase error : $e");
      return Left(FirestoreFailure(e.message ?? 'Firebase error'));
    } catch (e) {
      debugPrint("General error : $e");
      return Left(FirestoreFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> startConversation(
      String otherUserId) async {
    try {
      // 1. Get current user
      final UserEntity? currentUser = await userProfile.getUserProfile();
      if (currentUser == null) {
        return const Left(FirestoreFailure('No authenticated user'));
      }

      // 2. Validate participants
      if (currentUser.uid == otherUserId) {
        return const Left(FirestoreFailure('Cannot chat with yourself'));
      }

      // 3. Generate unique chat ID (sorted to prevent duplicate chats)
      final participants = [currentUser.uid, otherUserId]..sort();
      final chatId = participants.join('_');

      // 4. Check if chat already exists
      final chatRef = firebaseDatabase.ref('Chats/$chatId');
      final snapshot = await chatRef.get();

      ChatEntity chat;

      if (snapshot.exists) {
        // Existing chat - parse from Firebase
        chat = ChatEntity.fromJson(snapshot.value as Map<String, dynamic>);
      } else {
        // 5. Create new chat
        chat = ChatEntity(
          chatId: chatId,
          lastInteraction: DateTime.now(), // lastInteraction
          lastMessage: '', // lastMessage (empty)
          messages: [], // messages (empty)
          participants: participants,
        );

        // 6. Save to Firebase
        await chatRef.set(chat.toJson());

        // 7. Update user's chat list for both participants
        final updates = {
          'Users/${currentUser.uid}/chats/$chatId': true,
          'Users/$otherUserId/chats/$chatId': true,
        };
        await firebaseDatabase.ref().update(updates);
      }

      return Right(chat); // Return the ChatEntity
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Firebase error'));
    } catch (e) {
      return Left(FirestoreFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<void> receiveMessage() async {
    // Implement the logic to receive a message from the server
    // print('Receiving message...');
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    // Implement the logic to delete a message from the server
    // print('Deleting message with ID: $messageId');
  }
}
