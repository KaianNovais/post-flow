import 'package:dio/dio.dart';
import 'package:post_flow/core/error/exceptions.dart';
import 'package:post_flow/features/post/data/model/post_model.dart';
import 'package:post_flow/features/post/domain/entities/user_entity.dart';

abstract class PostRemoteDataSource {
  /// Obtém uma lista de posts com paginação
  /// Throws [ServerException] se ocorrer um erro no servidor
  Future<List<PostModel>> getPosts({required int page, required int limit});

  /// Obtém um post específico pelo ID
  /// Throws [ServerException] se ocorrer um erro no servidor
  Future<PostModel> getPostById(int id);

  /// Obtém o autor (usuário) de um post
  /// Throws [ServerException] se ocorrer um erro no servidor
  Future<PlaceholderUserModel> getPostAuthor(int userId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio dio;
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  PostRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PostModel>> getPosts({required int page, required int limit}) async {
    try {
      // Calculando o início da página (offset)
      final start = (page - 1) * limit;
      
      final response = await dio.get(
        '$baseUrl/posts',
        queryParameters: {
          '_start': start,
          '_limit': limit,
        },
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((postJson) => PostModel.fromJson(postJson))
            .toList();
      } else {
        throw ServerException(message: 'Falha ao carregar posts');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Falha ao carregar posts');
    }
  }

  @override
  Future<PostModel> getPostById(int id) async {
    try {
      final response = await dio.get('$baseUrl/posts/$id');

      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'Falha ao carregar o post');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Falha ao carregar o post');
    }
  }

  @override
  Future<PlaceholderUserModel> getPostAuthor(int userId) async {
    try {
      final response = await dio.get('$baseUrl/users/$userId');

      if (response.statusCode == 200) {
        return PlaceholderUserModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'Falha ao carregar o autor');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Falha ao carregar o autor');
    }
  }
}