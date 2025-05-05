abstract class AppException implements Exception {
  final String message;
  final StackTrace stackTrace;
  final String code;

  const AppException(this.message,
      [this.stackTrace = StackTrace.empty, this.code = '']);
}

// Firebase-specific exceptions
class FirebaseAuthException extends AppException {
  const FirebaseAuthException(
    super.message, [
    super.stackTrace = StackTrace.empty,
    super.code = '',
  ]);
}

class FirestoreException extends AppException {
  const FirestoreException(
    super.message, [
    super.stackTrace = StackTrace.empty,
    super.code = '',
  ]);
}

class FirebaseStorageException extends AppException {
  const FirebaseStorageException(
    super.message, [
    super.stackTrace = StackTrace.empty,
    super.code = '',
  ]);
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Network error',
    super.stackTrace = StackTrace.empty,
  ]);
}
