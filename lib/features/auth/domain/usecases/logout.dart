import 'package:dartz/dartz.dart';
import 'package:post_flow/core/error/failures.dart';
import 'package:post_flow/features/auth/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}