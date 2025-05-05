import 'package:autis/src/common/blocs/game_bloc/game_event.dart';
import 'package:autis/src/common/blocs/game_bloc/game_state.dart';
import 'package:bloc/bloc.dart';

import '../../repository/game_repository.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository _gameRepository;
  GameBloc(this._gameRepository) : super(GameInitial()) {
    on<UploadGame>(_onUploadGame);
    on<GetGames>(_onGetGames);
    on<OpenGame>(_onOpenGame);
    on<CloseGame>(_onCloseGame);
    on<UpdateGame>(_onUpdateGame);
    on<DeleteGame>(_onDeleteGame);
  }

  Future<void> _onUploadGame(UploadGame event, Emitter<GameState> emit) async {
    emit(GameLoading());
    try {
      final response = await _gameRepository.uploadGame(
        event.game,
        event.patientId,
      );
      response.fold(
        (failure) => emit(GameFailure(error: failure.toString())),
        (games) => emit(GamesLoaded(games)),
      );
    } catch (e) {
      emit(GameFailure(error: e.toString()));
    }
  }

  Future<void> _onGetGames(GetGames event, Emitter<GameState> emit) async {
    emit(GameLoading());
    try {
      final response = await _gameRepository.getAllGames(event.patientId);
      response.fold(
        (failure) => emit(GameFailure(error: failure.toString())),
        (games) => emit(GamesLoaded(games)),
      );
    } catch (e) {
      emit(GameFailure(error: e.toString()));
    }
  }

  void _onOpenGame(OpenGame event, Emitter<GameState> emit) {
    // Handle open game for patient logic
  }
  void _onCloseGame(CloseGame event, Emitter<GameState> emit) {
    // Handle close game for patient logic
  }
  Future<void> _onUpdateGame(UpdateGame event, Emitter<GameState> emit) async {
    emit(GameLoading());
    try {
      final response = await _gameRepository.updateGame(
        event.patientId,
        event.gameId,
        event.level,
        event.question,
        event.userAnswer,
      );
      response.fold(
        (failure) => emit(GameFailure(error: failure.toString())),
        (games) => emit(GamesLoaded(games)),
      );
    } catch (e) {
      emit(GameFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteGame(DeleteGame event, Emitter<GameState> emit) async {
    emit(GameLoading());
    try {
      final response = await _gameRepository.deleteGame(
        event.gameId,
        event.patientId,
      );
      response.fold(
        (failure) => emit(GameFailure(error: failure.toString())),
        (games) => emit(GamesLoaded(games)),
      );
    } catch (e) {
      emit(GameFailure(error: e.toString()));
    }
  }
}
