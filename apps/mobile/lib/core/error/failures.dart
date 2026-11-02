sealed class Failure {
  final String message;
  const Failure(this.message);
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
