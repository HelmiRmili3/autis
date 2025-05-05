import 'package:autis/core/services/secure_storage_service.dart';
import 'package:autis/core/utils/collections.dart';
import 'package:autis/src/patient/domain/entities/game_entity.dart';
import 'package:autis/core/errors/failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../core/types/either.dart';
import '../../../injection_container.dart';
import 'game_local_data_source.dart';

abstract class GameRemoteDataSource {
  Future<Either<Failure, List<GameEntity>>> uploadGame(
    GameEntity game,
    String patientId,
  );
  Future<Either<Failure, GameEntity>> getGameById(String id);
  Future<Either<Failure, void>> closeGame(String id);
  Future<Either<Failure, void>> openGame(String id);
  Future<Either<Failure, List<GameEntity>>> deleteGame(
    String id,
    String patientId,
  );
  Future<Either<Failure, List<GameEntity>>> updateGame(
    String patientId,
    String gameId,
    String level,
    int question,
    int userAnswer,
  );
  Future<Either<Failure, List<GameEntity>>> getAllGames(
    String? patientId,
  );
  Future<Either<Failure, GameEntity>> getlevels(
    String patientId,
    String gameId,
  );
  Future<Either<Failure, void>> getQuestions(
    String patientId,
    String gameId,
    String levelId,
  );
}

class GameRemoteDataSourceImpl implements GameRemoteDataSource {
  GameLocalDataSource gameLocalDataSource;
  FirebaseFirestore firebaseFirestore;

  GameRemoteDataSourceImpl(this.gameLocalDataSource, this.firebaseFirestore);

  @override
  Future<Either<Failure, void>> closeGame(String id) {
    // TODO: implement closeGame
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<GameEntity>>> deleteGame(
    String id,
    String patientId,
  ) async {
    try {
      debugPrint("id for the game : $id");
      // 2. Get reference to the game and its subcollections
      final gameDocRef = firebaseFirestore
          .collection(Collection.users)
          .doc(patientId)
          .collection(Collection.games)
          .doc(id);

      // 3. First check if document exists
      final gameDoc = await gameDocRef.get();
      if (!gameDoc.exists) {
        return const Left(FirestoreFailure("Game not found"));
      }

      // 4. Delete the game document and all its subcollections (if any)
      final batch = firebaseFirestore.batch();

      // Delete main game document
      batch.delete(gameDocRef);

      // Optional: Delete all levels subcollection if needed
      final levelsSnapshot =
          await gameDocRef.collection(Collection.levels).get();
      for (final doc in levelsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      // 5. Fetch updated games list
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .doc(patientId)
          .collection(Collection.games)
          .get();

      final games =
          snapshot.docs.map((doc) => GameEntity.fromJson(doc.data())).toList();

      return Right(games);
    } on FirebaseException catch (e) {
      debugPrint('Firestore error: ${e.message}');
      return Left(FirestoreFailure(e.message ?? "Failed to delete game"));
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return const Left(FirestoreFailure("An unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, List<GameEntity>>> getAllGames(
      String? patientId) async {
    try {
      // FETCH ALL THE GAMES
      if (patientId == null) {
        final user = await sl<UserProfileStorage>().getUserProfile();
        final snapshot = await firebaseFirestore
            .collection(Collection.users)
            .doc(user!.uid)
            .collection(Collection.games)
            .get();
        debugPrint(snapshot.toString());
        // TRANSFORM THE GAMES IN TO OPJECTS
        final games = snapshot.docs.map((doc) {
          return GameEntity.fromJson(doc.data());
        }).toList();
        // RETURN THE GAMES
        return Right(games);
      }
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .doc(patientId)
          .collection(Collection.games)
          .get();
      debugPrint(snapshot.toString());
      // TRANSFORM THE GAMES IN TO OPJECTS
      final games = snapshot.docs.map((doc) {
        return GameEntity.fromJson(doc.data());
      }).toList();
      // RETURN THE GAMES
      return Right(games);
    } catch (e) {
      debugPrint(e.toString());
      return const Left(FirestoreFailure("Failure uploading the game!"));
    }
  }

  @override
  Future<Either<Failure, GameEntity>> getGameById(String id) {
    // TODO: implement getGameById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> openGame(String id) {
    // TODO: implement openGame
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<GameEntity>>> updateGame(
    String patientId,
    String gameId,
    String level,
    int questionIndex,
    int userAnswer,
  ) async {
    try {
      final gameRef = firebaseFirestore
          .collection(Collection.users)
          .doc(patientId)
          .collection(Collection.games)
          .doc(gameId);

      // Transaction to ensure atomic update
      await firebaseFirestore.runTransaction((transaction) async {
        final gameDoc = await transaction.get(gameRef);
        if (!gameDoc.exists) throw Exception("Game not found");

        final gameData = Map<String, dynamic>.from(gameDoc.data()!);
        final levels = List<Map<String, dynamic>>.from(gameData['levels']);

        // Find the level
        final levelIndex =
            levels.indexWhere((l) => l['id'].toString() == level);
        if (levelIndex == -1) throw Exception("Level not found");

        // Create new copy of the level with updated questions
        final levelToUpdate = Map<String, dynamic>.from(levels[levelIndex]);
        final questions =
            List<Map<String, dynamic>>.from(levelToUpdate['questions']);

        // Update only the specific question
        questions[questionIndex] = {
          ...questions[questionIndex], // Keep all existing fields
          'userAnswerIndex': userAnswer, // Only update this
        };

        // Prepare the updated level
        final updatedLevel = {
          ...levelToUpdate,
          'questions': questions,
        };

        // Check if all questions are answered
        final allAnswered = questions.every((q) => q['userAnswerIndex'] != -1);
        if (allAnswered) {
          // Calculate level score
          final levelScore = questions.fold<int>(
              0,
              // ignore: avoid_types_as_parameter_names
              (sum, q) =>
                  sum +
                  ((q['userAnswerIndex'] == q['answerIndex'])
                      ? (q['questionScore'] as int)
                      : 0));

          // Calculate stars
          final stars = ((levelScore / levelToUpdate['maxScore']) * 3).round();

          updatedLevel.addAll({
            'userScore': levelScore,
            'stars': stars,
          });
        }

        // Create new levels array with only this level updated
        final updatedLevels = List<Map<String, dynamic>>.from(levels);
        updatedLevels[levelIndex] = updatedLevel;

        // Calculate total game score
        final totalScore =
            // ignore: avoid_types_as_parameter_names
            updatedLevels.fold<int>(
                // ignore: avoid_types_as_parameter_names
                0,
                // ignore: avoid_types_as_parameter_names
                (sum, l) => (sum + ((l['userScore'] ?? 0).toInt())).toInt());

        // Prepare final update
        transaction.update(gameRef, {
          'levels': updatedLevels,
          'userScore': totalScore,
        });
      });

      // Fetch updated games list
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .doc(patientId)
          .collection(Collection.games)
          .get();

      return Right(
          snapshot.docs.map((doc) => GameEntity.fromJson(doc.data())).toList());
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? "Firestore operation failed"));
    } catch (e) {
      return Left(FirestoreFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<GameEntity>>> uploadGame(
    GameEntity game,
    String patientId,
  ) async {
    try {
      // Start a batch write to ensure atomic operations
      final batch = firebaseFirestore.batch();

      // Reference to the game document
      final gameDocRef = firebaseFirestore
          .collection(Collection.users)
          .doc(patientId)
          .collection(Collection.games)
          .doc(game.id);

      // 1. Add the main game document
      batch.set(gameDocRef, game.toJson());

      // 2. Add all levels in subcollection
      for (final level in game.levels) {
        final levelDocRef =
            gameDocRef.collection(Collection.levels).doc(level.id.toString());
        batch.set(levelDocRef, level.toJson());
      }

      // Commit all operations as a single atomic unit
      await batch.commit();

      // 3. Fetch all games after successful upload
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .doc(patientId)
          .collection(Collection.games)
          .get();

      final games =
          snapshot.docs.map((doc) => GameEntity.fromJson(doc.data())).toList();

      return Right(games);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? "Firestore operation failed"));
    } catch (e) {
      return Left(FirestoreFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> getQuestions(
      String patientId, String gameId, String levelId) {
    // TODO: implement getQuestions
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, GameEntity>> getlevels(
      String patientId, String gameId) {
    // TODO: implement getlevels
    throw UnimplementedError();
  }
}
