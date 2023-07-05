import 'package:flutter/material.dart';
import 'package:todo_app/navigation/navigation_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screens/archive_todo.dart';
import 'package:todo_app/screens/done_todo.dart';
import 'package:todo_app/screens/progress_todo.dart';

class NavigationManager extends Cubit<NavigationState> {
  NavigationManager() : super(InitialState());

  static NavigationManager nav(context) =>
      BlocProvider.of<NavigationManager>(context);

  int currentNavBarIndex = 0;

  void setNavBarIndex(int index) {
    currentNavBarIndex = index;
    emit(NavBarIndexChanged());
  }

  List<String> navTitles = ['Tasks', 'Done', 'Archive'];
  List<StatelessWidget> screens = const [
    ProgressTodo(),
    DoneTodo(),
    ArchiveTodo()
  ];
}