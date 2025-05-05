import 'package:autis/src/patient/domain/entities/game_entity.dart';
import 'package:autis/src/patient/domain/entities/level_entity.dart';
import 'package:autis/src/patient/domain/entities/question_entity.dart';

abstract class GameState {}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GamesLoaded extends GameState {
  final List<GameEntity> games;
  GamesLoaded(this.games);
}

class LevelsLoaded extends GameState {
  final List<LevelEntity> games;
  LevelsLoaded(this.games);
}

class QuestionsLoaded extends GameState {
  final List<QuestionEntity> games;
  QuestionsLoaded(this.games);
}

class GameFailure extends GameState {
  final String error;
  GameFailure({required this.error});
}
