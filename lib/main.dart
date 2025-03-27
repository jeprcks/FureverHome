import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furever_home_admin/firebase_options.dart';
import 'package:furever_home_admin/views/screens/Events/bloc/event_bloc.dart';
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
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AuthCheckRequested()),
        ),
        BlocProvider<DogBloc>(
          create: (context) => DogBloc(),
        ),
        BlocProvider<EventBloc>(
          create: (context) => EventBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// main.dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      ),
    );
  }
}
