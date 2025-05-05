import 'package:autis/src/patient/domain/entities/game_entity.dart';

abstract class GameEvent {}

class UploadGame extends GameEvent {
  final GameEntity game;
  final String patientId;
  UploadGame(
    this.game,
    this.patientId,
  );
}

class GetGames extends GameEvent {
  String? patientId;
  GetGames(
    this.patientId,
  );
}

class Getlevels extends GameEvent {
  final String patientId;
  final String gameId;
  Getlevels(
    this.patientId,
    this.gameId,
  );
}

class GetQuestions extends GameEvent {
  final String patientId;
  final String gameId;
  final String levelId;
  GetQuestions(
    this.patientId,
    this.gameId,
    this.levelId,
  );
}

class OpenGame extends GameEvent {
  final GameEntity game;
  OpenGame(this.game);
}

class CloseGame extends GameEvent {
  final String gameId;
  CloseGame(this.gameId);
}

class UpdateGame extends GameEvent {
  final String patientId;
  final String gameId;
  final String level;
  final int question;
  final int userAnswer;
  UpdateGame(
    this.gameId,
    this.patientId,
    this.level,
    this.question,
    this.userAnswer,
  );
}

class DeleteGame extends GameEvent {
  final String gameId;
  final String patientId;
  DeleteGame(
    this.gameId,
    this.patientId,
  );
}
