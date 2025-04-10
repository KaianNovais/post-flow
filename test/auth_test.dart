import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:post_flow/core/error/failures.dart';
import 'package:post_flow/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:post_flow/features/auth/data/models/user_model.dart';
import 'package:post_flow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:post_flow/features/auth/domain/repositories/auth_repository.dart';
import 'package:post_flow/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:post_flow/features/auth/domain/usecases/logout.dart';
import 'package:post_flow/features/auth/domain/usecases/get_current_user.dart';

// Mocks
class MockFirebaseAuth extends Mock implements firebase.FirebaseAuth {}
class MockUserCredential extends Mock implements firebase.UserCredential {}
class MockFirebaseUser extends Mock implements firebase.User {}
class MockFirebaseAuthDataSource extends Mock implements FirebaseAuthDataSource {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  // Testes para o DataSource
  group('FirebaseAuthDataSource', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late FirebaseAuthDataSource dataSource;
    late MockUserCredential mockUserCredential;
    late MockFirebaseUser mockUser;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      dataSource = FirebaseAuthDataSourceImpl(firebaseAuth: mockFirebaseAuth);
      mockUserCredential = MockUserCredential();
      mockUser = MockFirebaseUser();

      // Configuração padrão para o mock de usuário
      when(() => mockUser.uid).thenReturn('test-uid');
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockUser.displayName).thenReturn('Test User');
      when(() => mockUser.photoURL).thenReturn(null);
      when(() => mockUserCredential.user).thenReturn(mockUser);
    });

    test('loginWithEmailAndPassword deve retornar UserModel quando login for bem-sucedido', () async {
      // Arrange
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      // Act
      final result = await dataSource.loginWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result, isA<UserModel>());
      expect(result.id, 'test-uid');
      expect(result.email, 'test@example.com');
      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    test('logout deve chamar signOut do FirebaseAuth', () async {
      // Arrange
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      // Act
      await dataSource.logout();

      // Assert
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('getCurrentUser deve retornar UserModel quando houver um usuário autenticado', () async {
      // Arrange
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      // Act
      final result = await dataSource.getCurrentUser();

      // Assert
      expect(result, isA<UserModel>());
      expect(result!.id, 'test-uid');
      expect(result.email, 'test@example.com');
    });

    test('getCurrentUser deve retornar null quando não houver um usuário autenticado', () async {
      // Arrange
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      // Act
      final result = await dataSource.getCurrentUser();

      // Assert
      expect(result, isNull);
    });
  });

  // Testes para o Repository
  group('AuthRepository', () {
    late MockFirebaseAuthDataSource mockDataSource;
    late AuthRepository repository;

    setUp(() {
      mockDataSource = MockFirebaseAuthDataSource();
      repository = AuthRepositoryImpl(dataSource: mockDataSource);
    });

    test('loginWithEmailAndPassword deve retornar Right(UserEntity) quando login for bem-sucedido', () async {
      // Arrange
      final userModel = UserModel(
        id: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
      );
      
      when(() => mockDataSource.loginWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => userModel);

      // Act
      final result = await repository.loginWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result, isA<Right>());
      expect(result.fold((l) => l, (r) => r), isA<UserModel>());
      verify(() => mockDataSource.loginWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    test('loginWithEmailAndPassword deve retornar Left(AuthFailure) quando ocorrer um erro', () async {
      // Arrange
      when(() => mockDataSource.loginWithEmailAndPassword(
        email: 'test@example.com',
        password: 'wrong-password',
      )).thenThrow(firebase.FirebaseAuthException(
        code: 'wrong-password',
        message: 'The password is invalid',
      ));

      // Act
      final result = await repository.loginWithEmailAndPassword(
        email: 'test@example.com',
        password: 'wrong-password',
      );

      // Assert
      expect(result, isA<Left>());
      expect(result.fold((l) => l, (r) => r), isA<AuthFailure>());
    });
  });

  // Testes para os UseCases
  group('UseCases', () {
    late MockAuthRepository mockRepository;
    late LoginWithEmailPassword loginUseCase;
    late Logout logoutUseCase;
    late GetCurrentUser getCurrentUserUseCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      loginUseCase = LoginWithEmailPassword(mockRepository);
      logoutUseCase = Logout(mockRepository);
      getCurrentUserUseCase = GetCurrentUser(mockRepository);
    });

    test('LoginWithEmailPassword deve retornar o resultado do repository', () async {
      // Arrange
      final userModel = UserModel(
        id: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
      );
      
      when(() => mockRepository.loginWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => Right(userModel));

      // Act
      final result = await loginUseCase(LoginParams(
        email: 'test@example.com',
        password: 'password123',
      ));

      // Assert
      expect(result, isA<Right>());
      expect(result.fold((l) => l, (r) => r), equals(userModel));
    });

    test('Logout deve retornar o resultado do repository', () async {
      // Arrange
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await logoutUseCase();

      // Assert
      expect(result, isA<Right>());
      verify(() => mockRepository.logout()).called(1);
    });

    test('GetCurrentUser deve retornar o resultado do repository', () async {
      // Arrange
      final userModel = UserModel(
        id: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: null,
      );
      
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Right(userModel));

      // Act
      final result = await getCurrentUserUseCase();

      // Assert
      expect(result, isA<Right>());
      expect(result.fold((l) => l, (r) => r), equals(userModel));
    });
  });
}