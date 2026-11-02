sealed class Failure {
  final String message;
  const Failure(this.message);
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// No usable network interface, or the host could not be read.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
