import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'views/screens/Dogs/bloc/dog_bloc.dart';
import 'views/screens/login/admin_signin_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      ),
    );
  }
}
