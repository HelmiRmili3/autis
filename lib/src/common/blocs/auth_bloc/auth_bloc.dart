import 'package:autis/core/params/authentication/login_user_params.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final FirebaseAuth firebaseAuth;
  final UserProfileStorage user;

  AuthBloc(
    this.authRepository,
    this.firebaseAuth,
    this.user,
  ) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<RegisterRequested>(_onRegisterRequested);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
  }

  Future<void> _onAuthStarted(
      AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthInitial());

    final userProfile = await user.getUserProfile();

    if (userProfile != null) {
      emit(Authenticated(userProfile));
      return;
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // 1. First register the user to get credentials
      final userCredential = await authRepository.register(Loginuserprams(
        email: event.user.email,
        password: event.user.password,
      ));

      // 2. Process registration result and get UID
      final uid = userCredential.fold(
        (failure) {
          debugPrint("Registration failed: $failure");
          emit(RegisterFailure(failure.message));
          return null; // Return null if failed
        },
        (authUser) =>
            authUser.user!.uid, // Extract UID from successful registration
      );

      // If registration failed (uid is null), stop here
      if (uid == null) return;

      // 3. Create user profile with the obtained UID
      // Assuming your User model has a copyWith or way to set UID

      final response =
          await authRepository.create(event.user.copyWith(uid: uid));

      response.fold(
        (failure) {
          debugPrint("Profile creation failed: $failure");
          emit(RegisterFailure(failure.message));
        },
        (user) {
          debugPrint("User registered & profile created: ${user.uid}");
          emit(RegisterSuccess());
          add(AuthLoggedIn(Loginuserprams(
            email: event.user.email,
            password: event.user.password,
          )));
        },
      );
    } catch (e) {
      debugPrint("Unexpected error: $e");
      emit(RegisterFailure("An unexpected error occurred"));
    }
  }

  Future<void> _onAuthLoggedIn(
      AuthLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    debugPrint("AuthLoggedIn: Attempting login...");

    try {
      // 1. First attempt to login
      final loginResponse = await authRepository.login(event.user);

      await loginResponse.fold(
        (failure) async {
          debugPrint("Error logging in user: $failure");
          emit(AuthenticationFailure(
            "Please check your credentials and try again",
          ));
          return; // Exit early on failure
        },
        (_) async {
          // 2. Get user profile after successful login

          // 3. Get additional user data
          final userDataResponse = await authRepository.getUser();

          await userDataResponse.fold(
            (failure) {
              // Still emit authenticated since login succeeded
              emit(AuthenticationFailure('Error getting user data: $failure'));
            },
            (userData) async {
              debugPrint("User : $userData");
              await user.saveUserProfile(userData);
              emit(Authenticated(userData));
            },
          );
        },
      );
    } catch (e) {
      debugPrint("AuthLoggedIn: Error = $e");
      emit(AuthenticationFailure(
        "An unexpected error occurred. Please try again",
      ));
    }
  }

  Future<void> _onAuthLoggedOut(
      AuthLoggedOut event, Emitter<AuthState> emit) async {
    try {
      // logout the user from Firebase
      // and clear the local storage
      final response = await authRepository.logout();
      await response.fold(
        (failure) {
          debugPrint("Error logging out user: $failure");
          emit(AuthenticationFailure(failure.message));
        },
        (___) async {
          debugPrint("User logged out successfully");
          await user.deleteUserProfile();
          emit(Unauthenticated());
        },
      );
    } catch (e) {
      debugPrint("Error logging out user in AuthLoggedOut event: $e");
      emit(AuthenticationFailure(e.toString()));
    }
  }
}
