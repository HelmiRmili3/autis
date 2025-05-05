// firebase_exception_handler.dart
import 'package:autis/core/errors/exceptions.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseExceptionHandler {
  static AppException handleFirebaseException(FirebaseException e) {
    switch (e.plugin) {
      case 'firebase_auth':
        return FirebaseAuthException(
            _getAuthErrorMessage(e.code, e.message ?? 'Authentication failed'),
            e.stackTrace ?? StackTrace.empty,
            e.code);
      case 'firebase_storage':
        return FirebaseStorageException(
          _getStorageErrorMessage(
              e.code, e.message ?? 'Storage operation failed'),
          e.stackTrace ?? StackTrace.empty,
          e.code,
        );
      case 'cloud_firestore':
        return FirestoreException(
          _getFirestoreErrorMessage(
              e.code, e.message ?? 'Firestore operation failed'),
          e.stackTrace ?? StackTrace.empty,
          e.code,
        );
      default:
        return FirestoreException(
          e.message ?? 'Firebase operation failed',
          e.stackTrace ?? StackTrace.empty,
          e.code,
        );
    }
  }

  static String _getAuthErrorMessage(String code, String defaultMessage) {
    switch (code) {
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
        return 'Incorrect password';
      case 'network-request-failed':
        return 'Network error occurred';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'invalid-email':
        return 'Invalid email format';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-disabled':
        return 'Account is disabled';
      default:
        return defaultMessage;
    }
  }

  static String _getFirestoreErrorMessage(String code, String defaultMessage) {
    switch (code) {
      case 'permission-denied':
        return 'Permission denied';
      case 'not-found':
        return 'Document not found';
      case 'unavailable':
        return 'Service unavailable';
      case 'resource-exhausted':
        return 'Quota exceeded';
      case 'failed-precondition':
        return 'Operation rejected';
      case 'aborted':
        return 'Operation aborted';
      case 'invalid-argument':
        return 'Invalid data provided';
      default:
        return defaultMessage;
    }
  }

  static String _getStorageErrorMessage(String code, String defaultMessage) {
    switch (code) {
      case 'object-not-found':
        return 'File not found';
      case 'unauthorized':
        return 'Unauthorized access';
      case 'canceled':
        return 'Operation canceled';
      case 'unknown':
        return 'Unknown error occurred';
      default:
        return defaultMessage;
    }
  }
}
