import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_flow/core/widgets/custom_snackbar.dart';
import 'package:post_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:post_flow/features/auth/presentation/bloc/auth_event.dart';
import 'package:post_flow/features/auth/presentation/bloc/auth_state.dart';
import 'package:post_flow/features/auth/presentation/pages/login_page.dart';
import 'package:post_flow/features/post/presentation/bloc/post_bloc.dart';
import 'package:post_flow/features/post/presentation/pages/posts_page.dart';
import 'package:post_flow/firebase_options.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Move o MultiBlocProvider para envolver o MaterialApp
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (context) => di.sl<PostBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Post Flow',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const AppStartScreen(),
      ),
    );
  }
}

class AppStartScreen extends StatelessWidget {
  const AppStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          CustomSnackbar.show(
            context: context,
            message: state.message,
            isError: true,
          );
        } else if (state is Authenticated) {
          CustomSnackbar.show(
            context: context,
            message: 'Login realizado com sucesso!',
            isError: false,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is Authenticated) {
          return const PostsPage();
        } else {
          // Para Unauthenticated e AuthError, mostra tela de login
          return const LoginPage();
        }
      },
    );
  }
}