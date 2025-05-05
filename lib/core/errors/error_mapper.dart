// error_mapper.dart
import 'package:autis/core/errors/exceptions.dart';
import 'package:autis/core/errors/failures.dart';

class ErrorMapper {
  Failure mapException(AppException exception) {
    if (exception is FirebaseAuthException) {
      return FirebaseAuthFailure(
          exception.message, exception.stackTrace, exception.code);
    } else if (exception is FirestoreException) {
      return FirestoreFailure(
          exception.message, exception.stackTrace, exception.code);
    } else if (exception is FirebaseStorageException) {
      return FirebaseStorageFailure(
          exception.message, exception.stackTrace, exception.code);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message, exception.stackTrace);
    } else {
      return UnexpectedFailure(exception.message, exception.stackTrace);
    }
  }
}
