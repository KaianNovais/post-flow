import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:post_flow/core/error/failures.dart';
import 'package:post_flow/features/post/domain/entities/post_entity.dart';
import 'package:post_flow/features/post/domain/repositories/post_repository.dart';
import 'package:post_flow/features/post/domain/usecases/usecase.dart';


class GetPosts implements UseCase<List<PostEntity>, PostsParams> {
  final PostRepository repository;

  GetPosts(this.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(PostsParams params) async {
    return await repository.getPosts(
      page: params.page,
      limit: params.limit,
    );
  }
}

class PostsParams extends Equatable {
  final int page;
  final int limit;

  const PostsParams({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object> get props => [page, limit];
}