<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furever_home_admin/firebase_options.dart';
import 'package:furever_home_admin/views/screens/authentication/bloc/auth_bloc.dart';
import 'package:furever_home_admin/views/screens/authentication/bloc/auth_event.dart';
import 'package:furever_home_admin/views/screens/authentication/bloc/auth_state.dart';
import 'package:furever_home_admin/views/screens/authentication/repository/auth_repository.dart';
import 'package:furever_home_admin/views/screens/homepage/admin_homepage.dart';
import 'views/screens/Dogs/bloc/dog_bloc.dart';
import 'views/screens/authentication/login/admin_signin_view.dart';

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure Firebase Storage for web
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    FirebaseStorage.instance.setMaxUploadRetryTime(const Duration(seconds: 30));
    FirebaseStorage.instance
        .setMaxOperationRetryTime(const Duration(seconds: 30));
    FirebaseStorage.instance
        .setMaxDownloadRetryTime(const Duration(seconds: 30));
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AuthCheckRequested()),
        ),
        // Add DogBloc provider
        BlocProvider<DogBloc>(
          create: (context) => DogBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// main.dart
=======
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'views/screens/Dogs/bloc/dog_bloc.dart';
import 'views/screens/login/admin_signin_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      title: 'Furever Home Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Force navigation to AdminHomeView when authentication is successful
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const AdminHomeView(),
              ),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // Show loading screen for initial state
            if (state is AuthInitial || state is AuthLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is Authenticated) {
              return const AdminHomeView();
            }

            return AdminSignInView();
          },
        ),
=======
    return MultiBlocProvider(
      providers: [
        BlocProvider<DogBloc>(
          create: (context) => DogBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Furever Home Admin',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AdminSignInView(),
>>>>>>> 749f3cfcf46c5f13a58aa0691cf37d6685291481
      ),
    );
  }
}
