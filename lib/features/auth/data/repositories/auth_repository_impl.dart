import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:post_flow/core/error/failures.dart';
import 'package:post_flow/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:post_flow/features/auth/domain/entities/user_entity.dart';
import 'package:post_flow/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await dataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } on FirebaseAuthException catch (e) {
      // Certifique-se de que o código de erro está sendo passado corretamente
      final errorMessage = e.message ?? 'Erro de autenticação: ${e.code}';
      return Left(AuthFailure(message: errorMessage));
    } catch (e) {
      // Registrar o erro inesperado para depuração
      debugPrint('Erro inesperado no login: $e');
      return Left(ServerFailure(message: 'Ocorreu um erro inesperado. Tente novamente.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure(message: 'Logout falhou'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await dataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return const Left(ServerFailure(message: 'Falha ao obter usuário atual'));
    }
  }
}