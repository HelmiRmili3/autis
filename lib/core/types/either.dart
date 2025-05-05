// either.dart
abstract class Either<L, R> {
  const Either();

  T fold<T>(T Function(L) onLeft, T Function(R) onRight);

  bool isLeft() => fold((_) => true, (_) => false);
  bool isRight() => fold((_) => false, (_) => true);

  L get left => fold((l) => l, (r) => throw Exception('No left value'));
  R get right => fold((l) => throw Exception('No right value'), (r) => r);
}

class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => onLeft(value);
}

class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => onRight(value);
}
