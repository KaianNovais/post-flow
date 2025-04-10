import 'package:dartz/dartz.dart';
import 'package:post_flow/core/error/failures.dart';
import 'package:post_flow/features/auth/domain/entities/user_entity.dart';
import 'package:post_flow/features/post/domain/entities/post_entity.dart';


abstract class PostRepository {
  /// Obtém uma lista de posts com paginação
  Future<Either<Failure, List<PostEntity>>> getPosts({required int page, required int limit});
  
  /// Obtém um post específico pelo ID
  Future<Either<Failure, PostEntity>> getPostById(int id);
  
  /// Obtém o autor (usuário) de um post
  Future<Either<Failure, UserEntity>> getPostAuthor(int userId);
}