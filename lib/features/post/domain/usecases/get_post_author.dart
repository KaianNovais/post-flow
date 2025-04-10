import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:post_flow/core/error/failures.dart';
import 'package:post_flow/features/auth/domain/entities/user_entity.dart';
import 'package:post_flow/features/post/domain/repositories/post_repository.dart';
import 'package:post_flow/features/post/domain/usecases/usecase.dart';


class GetPostAuthor implements UseCase<UserEntity, AuthorParams> {
  final PostRepository repository;

  GetPostAuthor(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(AuthorParams params) async {
    return await repository.getPostAuthor(params.userId);
  }
}

class AuthorParams extends Equatable {
  final int userId;

  const AuthorParams({required this.userId});

  @override
  List<Object> get props => [userId];
}