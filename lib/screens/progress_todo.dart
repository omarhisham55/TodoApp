import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/components/components.dart';
import 'package:todo_app/components/constants.dart';
import 'package:todo_app/components/style/color.dart';
import 'package:todo_app/screens/screens_bloc/screens_bloc.dart';
import 'package:todo_app/screens/screens_bloc/screens_states.dart';

class ProgressTodo extends StatelessWidget {
  const ProgressTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScreenManager, ScreenState>(
        listener: (context, state) {},
        builder: (context, state) {
          ScreenManager screenManager = ScreenManager.screenManager(context);
          List<Map> newTasks = allTasks;
          return (newTasks.isEmpty)
              ? Center(child: titleText(text: 'No Todos Yet'))
              : ListView.separated(
                  itemBuilder: (context, i) => buildNewTask(
                      i: i, model: newTasks[i], screenManager: screenManager),
                  separatorBuilder: (context, i) => const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: Divider(
                          height: 5.0,
                          color: BackgroundColors.blackBG,
                        ),
                      ),
                  itemCount: newTasks.length);
        });
  }
}
