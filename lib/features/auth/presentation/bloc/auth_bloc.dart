import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_flow/core/error/failures.dart';
import 'package:post_flow/features/auth/domain/usecases/get_current_user.dart';
import 'package:post_flow/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:post_flow/features/auth/domain/usecases/logout.dart';
import 'package:post_flow/features/auth/presentation/bloc/auth_event.dart';
import 'package:post_flow/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmailPassword loginWithEmailPassword;
  final Logout logout;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.loginWithEmailPassword,
    required this.logout,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
  }

  Future<void> _onLoginEvent(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {

    debugPrint('AuthBloc: Iniciando login para ${event.email}');
    
    final result = await loginWithEmailPassword(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    
    result.fold(
      (failure) {
        String errorMessage = 'Ocorreu um erro durante o login';
        
        if (failure is AuthFailure) {
          debugPrint('AuthBloc: Erro de login: $failure');
          // Tratamento de erros específicos do Firebase em português
          final errorCode = failure.message.toLowerCase();
          
          if (errorCode.contains('user-not-found') || errorCode.contains('usuário não encontrado')) {
            errorMessage = 'Usuário não encontrado. Verifique seu email.';
          } else if (errorCode.contains('wrong-password') || errorCode.contains('senha incorreta')) {
            errorMessage = 'Senha incorreta. Tente novamente.';
          } else if (errorCode.contains('invalid-email') || errorCode.contains('email inválido')) {
            errorMessage = 'Email inválido. Verifique o formato.';
          } else if (errorCode.contains('too-many-requests') || errorCode.contains('muitas tentativas')) {
            errorMessage = 'Muitas tentativas. Tente novamente mais tarde.';
          } else if (errorCode.contains('user-disabled') || errorCode.contains('usuário desativado')) {
            errorMessage = 'Esta conta foi desativada.';
          } else if (errorCode.contains('email-already-in-use') || errorCode.contains('email já em uso')) {
            errorMessage = 'Este email já está sendo usado por outra conta.';
          } else if (errorCode.contains('weak-password') || errorCode.contains('senha fraca')) {
            errorMessage = 'A senha é muito fraca. Use pelo menos 6 caracteres.';
          } else if (errorCode.contains('operation-not-allowed') || errorCode.contains('operação não permitida')) {
            errorMessage = 'Operação não permitida. Contate o suporte.';
          } else if (errorCode.contains('account-exists-with-different-credential') || errorCode.contains('conta existente')) {
            errorMessage = 'Já existe uma conta com este email, mas com credenciais diferentes.';
          } else if (errorCode.contains('invalid-credential') || errorCode.contains('credencial inválida')) {
            errorMessage = 'Credencial inválida. Verifique suas informações.';
          } else if (errorCode.contains('network-request-failed') || errorCode.contains('falha na rede')) {
            errorMessage = 'Falha na conexão de rede. Verifique sua internet.';
          } else if (errorCode.contains('malformed') || errorCode.contains('expired')) {
            errorMessage = 'A credencial fornecida está malformada ou expirou. Tente novamente.';
          } else {
            
            errorMessage = failure.message;
          }
        } else if (failure is ServerFailure) {
          errorMessage = failure.message;
        } else if (failure is NetworkFailure) {
          errorMessage = 'Falha na conexão. Verifique sua internet.';
        }
        
        emit(AuthError(message: errorMessage));
      },
      (user) {
        debugPrint('AuthBloc: Login bem-sucedido para ${user.email}');
        emit(Authenticated(user: user));
      },
    );
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    
    emit(AuthLoading());
    debugPrint('AuthBloc: Iniciando logout');
    
    final result = await logout();
    
    result.fold(
      (failure) {
        debugPrint('AuthBloc: Erro no logout: $failure');
        String errorMessage = 'Erro ao fazer logout';
        emit(AuthError(message: errorMessage));
      },
      (_) {
        debugPrint('AuthBloc: Logout bem-sucedido');
        emit(Unauthenticated());
      },
    );
  }

  Future<void> _onCheckAuthStatusEvent(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    // Aqui emitimos o loading para mostrar feedback durante a inicialização do app
    emit(AuthLoading());
    debugPrint('AuthBloc: Verificando status de autenticação');
    
    final result = await getCurrentUser();
    
    result.fold(
      (failure) {
        debugPrint('AuthBloc: Erro ao verificar status: $failure');
        emit(Unauthenticated());
      },
      (user) {
        if (user != null) {
          debugPrint('AuthBloc: Usuário autenticado: ${user.email}');
          emit(Authenticated(user: user));
        } else {
          debugPrint('AuthBloc: Usuário não autenticado');
          emit(Unauthenticated());
        }
      },
    );
  }
}