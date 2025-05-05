import 'package:autis/src/common/blocs/profile_bloc/profile_event.dart';
import 'package:autis/src/common/blocs/profile_bloc/profile_state.dart';
import 'package:autis/src/common/repository/profile_repository.dart';
import 'package:bloc/bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
    on<ProfileEvent>(_onProfileStarted);
    // on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    // on<ProfileImageUpdateRequested>(_onProfileImageUpdateRequested);
  }

  Future<void> _onProfileStarted(
      ProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // final userProfile = await profileRepository.getUserProfile(event.uid);
      // emit(ProfileLoaded(userProfile));
    } catch (e) {
      emit(ProfileFailure("Error loading profile: $e"));
    }
  }
}
