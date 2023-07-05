import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:todo_app/navigation/navigation_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/navigation/navigation_states.dart';
import 'package:todo_app/screens/deleted_todo.dart';
import 'package:todo_app/screens/screens_bloc/screens_bloc.dart';
import 'package:todo_app/screens/screens_bloc/screens_states.dart';

import '../components/constants.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationManager, NavigationState>(
        listener: (context, state) {},
        builder: (context, state) {
          NavigationManager nav = NavigationManager.nav(context);
          return BlocConsumer<ScreenManager, ScreenState>(
              listener: (context, state) {},
              builder: (context, state) {
                ScreenManager screenManager =
                    ScreenManager.screenManager(context);
                return Scaffold(
                  key: screenManager.scaffoldKey,
                  appBar: AppBar(
                    title: Text(nav.navTitles[nav.currentNavBarIndex]),
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const DeletedTodo()));
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                  body: Conditional.single(
                      context: context,
                      conditionBuilder: (context) =>
                          state is! GetDatabaseLoadingState,
                      widgetBuilder: (context) =>
                          nav.screens[nav.currentNavBarIndex],
                      fallbackBuilder: (context) =>
                          const Center(child: CircularProgressIndicator())),
                  bottomNavigationBar: BottomNavigationBar(
                      currentIndex: nav.currentNavBarIndex,
                      onTap: (value) => nav.setNavBarIndex(value),
                      items: const [
                        BottomNavigationBarItem(
                            label: '', icon: Icon(Icons.task_outlined)),
                        BottomNavigationBarItem(
                            label: '', icon: Icon(Icons.task_rounded)),
                        BottomNavigationBarItem(
                            label: '', icon: Icon(Icons.archive)),
                      ]),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      (screenManager.isBottomSheetOpened)
                          ? {
                              if (screenManager.formState.currentState!
                                  .validate())
                                {
                                  debugPrint(
                                      'name ${screenManager.todoName.text} description ${screenManager.todoDesc.text} time ${screenManager.todoTime.text} date ${screenManager.todoDate.text}'),
                                  screenManager
                                      .insertToDatabase(
                                          screenManager.todoName.text,
                                          screenManager.todoDesc.text,
                                          screenManager.todoTime.text,
                                          screenManager.todoDate.text)
                                      .then((value) {
                                    screenManager.isBottomSheetOpened = false;
                                    screenManager.changeFloatingIcon();
                                    Navigator.pop(context);
                                  }).catchError((e) {
                                    debugPrint(e.toString());
                                  })
                                },
                            }
                          : {
                              screenManager.isBottomSheetOpened = true,
                              screenManager.changeFloatingIcon(),
                              screenManager.scaffoldKey.currentState!
                                  .showBottomSheet((context) {
                                    return bottomFormSheet(
                                        key: screenManager.formState,
                                        context: context,
                                        todoName: screenManager.todoName,
                                        todoDesc: screenManager.todoDesc,
                                        todoDate: screenManager.todoDate,
                                        todoTime: screenManager.todoTime);
                                  })
                                  .closed
                                  .then((value) {
                                    screenManager.isBottomSheetOpened = false;
                                    screenManager.changeFloatingIcon();
                                  })
                            };
                    },
                    tooltip: 'Add',
                    child: screenManager.addFloatingButton,
                  ),
                );
              });
        });
  }
}
