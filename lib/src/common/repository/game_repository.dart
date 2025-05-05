import '../../../core/errors/failures.dart';
import '../../../core/types/either.dart';
import '../../patient/domain/entities/game_entity.dart';

abstract class GameRepository {
  Future<Either<Failure, List<GameEntity>>> uploadGame(
    GameEntity game,
    String patientId,
  );
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
  // game related
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
