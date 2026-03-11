import 'package:fpdart/fpdart.dart';
import 'package:flutter_tdd_clean_arc/core/errors/failures.dart';

/// Contract that every Use Case must implement.
///
/// [Type] is the success return type.
/// [Params] is the parameter object passed to the use case.
/// Use [NoParams] when a use case requires no input.
abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Use this when a use case takes no parameters.
final class NoParams {
  const NoParams();
}
