// lib/core/di/injection_container.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:post_flow/core/network/network_info.dart';
import 'package:post_flow/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:post_flow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:post_flow/features/auth/domain/repositories/auth_repository.dart';
import 'package:post_flow/features/auth/domain/usecases/get_current_user.dart';
import 'package:post_flow/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:post_flow/features/auth/domain/usecases/logout.dart';
import 'package:post_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:post_flow/features/post/data/datasources/post_remote_datasource.dart';
import 'package:post_flow/features/post/data/repositories/post_repository_impl.dart';
import 'package:post_flow/features/post/domain/repositories/post_repository.dart';
import 'package:post_flow/features/post/domain/usecases/get_post_author.dart';
import 'package:post_flow/features/post/domain/usecases/get_post_details.dart';
import 'package:post_flow/features/post/domain/usecases/get_posts.dart';
import 'package:post_flow/features/post/presentation/bloc/post_bloc.dart';


final sl = GetIt.instance;

Future<void> init() async {
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => Dio());

  //! Features - Auth
  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginWithEmailPassword: sl(),
      logout: sl(),
      getCurrentUser: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginWithEmailPassword(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(firebaseAuth: sl()),
  );

  //! Features - Posts
  // BLoC
  sl.registerFactory(
    () => PostBloc(
      getPosts: sl(),
      getPostDetails: sl(),
      getPostAuthor: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPosts(sl()));
  sl.registerLazySingleton(() => GetPostDetails(sl()));
  sl.registerLazySingleton(() => GetPostAuthor(sl()));

  // Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(dio: sl()),
  );

  //! External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}