// Auth Events

import 'package:autis/core/params/authentication/create_user_params.dart';
import 'package:autis/core/params/authentication/login_user_params.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final Loginuserprams user;
  AuthLoggedIn(this.user);
}

class AuthLoggedOut extends AuthEvent {}

class RegisterRequested extends AuthEvent {
  final CreateUserParams user;
  RegisterRequested(this.user);
}

class RegisterSuccessEvent extends AuthEvent {}

class RegisterFailureEvent extends AuthEvent {
  final String error;
  RegisterFailureEvent(this.error);
}
