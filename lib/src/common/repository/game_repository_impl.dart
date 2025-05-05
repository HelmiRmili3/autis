import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/data/game_remote_data_source.dart';
import 'package:autis/src/common/repository/game_repository.dart';
import 'package:autis/src/patient/domain/entities/game_entity.dart';

class GameRepositoryImpl implements GameRepository {
  final GameRemoteDataSource _gameRemoteDataSource;
  GameRepositoryImpl(this._gameRemoteDataSource);

  @override
  Future<Either<Failure, List<GameEntity>>> getAllGames(String? patientId) {
    return _gameRemoteDataSource.getAllGames(patientId);
  }

  @override
  Future<Either<Failure, void>> getQuestions(
      String patientId, String gameId, String levelId) {
    return _gameRemoteDataSource.getQuestions(patientId, gameId, levelId);
  }

  @override
  Future<Either<Failure, GameEntity>> getlevels(
      String patientId, String gameId) {
    return _gameRemoteDataSource.getlevels(patientId, gameId);
  }

  @override
  Future<Either<Failure, void>> openGame(String id) {
    return _gameRemoteDataSource.openGame(id);
  }

  @override
  Future<Either<Failure, List<GameEntity>>> updateGame(
    String patientId,
    String gameId,
    String level,
    int question,
    int userAnswer,
  ) {
    return _gameRemoteDataSource.updateGame(
      patientId,
      gameId,
      level,
      question,
      userAnswer,
    );
  }

  @override
  Future<Either<Failure, List<GameEntity>>> uploadGame(
      GameEntity game, String patientId) {
    return _gameRemoteDataSource.uploadGame(
      game,
      patientId,
    );
  }

  @override
  Future<Either<Failure, void>> closeGame(String id) {
    return _gameRemoteDataSource.closeGame(id);
  }

  @override
  Future<Either<Failure, List<GameEntity>>> deleteGame(
      String id, String patientId) {
    return _gameRemoteDataSource.deleteGame(id, patientId);
  }
}
