import 'package:dartz/dartz.dart';
import 'package:post_flow/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Para casos de uso que não requerem parâmetros
class NoParams {}