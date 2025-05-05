abstract class Failure {
  final String message;
  final StackTrace stackTrace;
  final String code;

  const Failure(this.message,
      [this.stackTrace = StackTrace.empty, this.code = '']);

  @override
  String toString() =>
      '[$runtimeType] $message${code.isNotEmpty ? ' (Code: $code)' : ''}';
}

class FirebaseAuthFailure extends Failure {
  const FirebaseAuthFailure(
    super.message, [
    super.stackTrace = StackTrace.empty,
    super.code = '',
  ]);
}

class FirestoreFailure extends Failure {
  const FirestoreFailure(
    super.message, [
    super.stackTrace = StackTrace.empty,
    super.code = '',
  ]);
}

class FirebaseStorageFailure extends Failure {
  const FirebaseStorageFailure(
    super.message, [
    super.stackTrace = StackTrace.empty,
    super.code = '',
  ]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Network error',
    super.stackTrace = StackTrace.empty,
  ]);
}

class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure([
    super.message = 'Permission denied',
    super.stackTrace = StackTrace.empty,
  ]);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'Unexpected error',
    super.stackTrace = StackTrace.empty,
  ]);
}
