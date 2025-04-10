import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:post_flow/core/error/failures.dart';
import 'package:post_flow/features/auth/domain/entities/user_entity.dart';
import 'package:post_flow/features/auth/domain/repositories/auth_repository.dart';

class LoginWithEmailPassword {
  final AuthRepository repository;

  LoginWithEmailPassword(this.repository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.loginWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}