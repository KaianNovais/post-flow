import 'package:dartz/dartz.dart';
import 'package:post_flow/core/error/failures.dart';
import 'package:post_flow/features/auth/domain/entities/user_entity.dart';
import 'package:post_flow/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<Either<Failure, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}