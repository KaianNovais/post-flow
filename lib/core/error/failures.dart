import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final String message;

  const ServerFailure({this.message = 'Server Failure'});

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  final String message;

  const AuthFailure({this.message = 'Authentication Failure'});

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  final String message;

  const NetworkFailure({this.message = 'Network Failure'});

  @override
  List<Object?> get props => [message];
}