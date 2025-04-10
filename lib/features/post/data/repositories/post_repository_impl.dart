import 'package:dartz/dartz.dart';
import 'package:post_flow/core/error/exceptions.dart';
import 'package:post_flow/core/error/failures.dart';
import 'package:post_flow/core/network/network_info.dart';
import 'package:post_flow/features/auth/domain/entities/user_entity.dart';
import 'package:post_flow/features/post/data/datasources/post_remote_datasource.dart';
import 'package:post_flow/features/post/domain/entities/post_entity.dart';
import 'package:post_flow/features/post/domain/repositories/post_repository.dart';


class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({required int page, required int limit}) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getPosts(page: page, limit: limit);
        return Right(remotePosts);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'Sem conexão com a internet'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePost = await remoteDataSource.getPostById(id);
        return Right(remotePost);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'Sem conexão com a internet'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getPostAuthor(int userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.getPostAuthor(userId);
        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'Sem conexão com a internet'));
    }
  }
}