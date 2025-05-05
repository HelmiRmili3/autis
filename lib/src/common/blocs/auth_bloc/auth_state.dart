// Auth States

import 'package:autis/src/common/entitys/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthenticationFailure extends AuthState {
  final String error;
  AuthenticationFailure(this.error);
}

class RegisterSuccess extends AuthState {}

class RegisterFailure extends AuthState {
  final String error;
  RegisterFailure(this.error);
}
