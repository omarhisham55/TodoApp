import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/navigation/navigation.dart';
import 'package:todo_app/navigation/navigation_bloc.dart';
import 'package:todo_app/screens/screens_bloc/screens_bloc.dart';
import 'bloc/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => NavigationManager(),
        child: BlocProvider(
          create: (context) => ScreenManager()..createDataBase(),
          child: const Navigation(),
        )
        ),
    );
  }
}