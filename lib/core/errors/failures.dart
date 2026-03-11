import 'package:equatable/equatable.dart';

/// Base class for all domain-layer failures.
/// Sealed so the presentation layer can exhaustively pattern-match on them.
sealed class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Failure caused by a remote server error.
final class ServerFailure extends Failure {
  const ServerFailure({super.message = 'A server error occurred.'});
}

/// Failure caused by no internet connectivity.
final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

/// Failure caused by a local cache error.
final class CacheFailure extends Failure {
  const CacheFailure({super.message = 'A cache error occurred.'});
}
