import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/components/constants.dart';
import 'package:todo_app/screens/screens_bloc/screens_bloc.dart';
import 'package:todo_app/screens/screens_bloc/screens_states.dart';

import '../components/components.dart';
import '../components/style/color.dart';

class DeletedTodo extends StatelessWidget {
  const DeletedTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScreenManager(),
      child: BlocConsumer<ScreenManager, ScreenState>(
        listener: (context, state) {},
        builder: (context, state) {
          List<Map> deleted = deletedTasks;
          return Scaffold(
            body: (deleted.isEmpty)
                ? Center(child: titleText(text: 'No Todos Deleted'))
                : ListView.separated(
                    itemBuilder: (context, i) => ListTile(
                          leading: CircleAvatar(
                            child: titleText(text: '${i + 1}'),
                          ),
                          title: titleText(text: deleted[i]['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              normalText(text: deleted[i]['description']),
                              normalText(text: deleted[i]['date']),
                            ],
                          ),
                          trailing: normalText(text: deleted[i]['time']),
                        ),
                    separatorBuilder: (context, i) => const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          child: Divider(
                            height: 5.0,
                            color: BackgroundColors.blackBG,
                          ),
                        ),
                    itemCount: deleted.length),
          );
        },
      ),
    );
  }
}
