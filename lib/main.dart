import 'package:firebase_login/login/login_screen.dart';
import 'package:firebase_login/simple_bloc_delegate.dart';
import 'package:firebase_login/splash_screen.dart';
import 'package:firebase_login/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'authentication_bloc/authentication_barell.dart';
import 'home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      theme:
          ThemeData(backgroundColor: Colors.amber, primarySwatch: Colors.blue),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized)
            return SplashScreen();
          else if (state is Unauthenticated)
            return LoginScreen(userRepository: _userRepository);
          else if (state is Authenticated) return HomeScreen();
        },
      ),
    );
  }
}
