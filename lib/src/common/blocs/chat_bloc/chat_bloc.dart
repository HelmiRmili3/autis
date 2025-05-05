import 'package:autis/core/services/secure_storage_service.dart';
import 'package:autis/src/common/repository/chat_repository.dart';

import 'package:bloc/bloc.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final UserProfileStorage user;

  ChatBloc(
    this.chatRepository,
    this.user,
  ) : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<GetChat>(_onGetChat);
    on<CreateConversation>(_onCreateConversation);
  }
  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoading());
      final response = await chatRepository.sendMessage(
        event.chatId,
        event.message,
      );
      response.fold((failure) {
        emit(ChatFailure(failure.toString()));
      }, (chat) {
        emit(ChatLoaded(chat));
      });
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onGetChat(
    GetChat event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoading());
      final response = await chatRepository.getChat(event.patientId);
      response.fold((failure) {
        emit(ChatFailure(failure.toString()));
      }, (chat) {
        emit(ChatLoaded(chat));
      });
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onCreateConversation(
    CreateConversation event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoading());

      final response = await chatRepository.startConversation(event.userId);
      response.fold((failure) {
        emit(ChatFailure(failure.toString()));
      }, (chat) {
        emit(ChatLoaded(chat));
      });
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }
}
