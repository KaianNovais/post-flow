import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:post_flow/core/error/failures.dart';
import 'package:post_flow/features/post/domain/entities/post_entity.dart';
import 'package:post_flow/features/post/domain/repositories/post_repository.dart';
import 'package:post_flow/features/post/domain/usecases/usecase.dart';


class GetPostDetails implements UseCase<PostEntity, PostDetailParams> {
  final PostRepository repository;

  GetPostDetails(this.repository);

  @override
  Future<Either<Failure, PostEntity>> call(PostDetailParams params) async {
    return await repository.getPostById(params.postId);
  }
}

class PostDetailParams extends Equatable {
  final int postId;

  const PostDetailParams({required this.postId});

  @override
  List<Object> get props => [postId];
}