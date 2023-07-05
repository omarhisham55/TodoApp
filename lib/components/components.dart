import 'package:flutter/material.dart';
import 'package:todo_app/components/constants.dart';
import 'package:todo_app/screens/screens_bloc/screens_bloc.dart';

import 'style/color.dart';

Widget normalText({
  required String text,
  Color? color,
  FontWeight? fontWeight,
  double? fontSize,
}) =>
    Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );

Widget titleText({
  required String text,
  Color? color,
  FontWeight? fontWeight,
  double? fontSize,
}) =>
    Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: fontSize ?? 25.0,
      ),
    );

Widget addTextFeild({
  required BuildContext context,
  required String text,
  required TextEditingController controller,
  String? Function(String?)? validator,
  double? widthSize,
  bool? enabled,
  Function()? onTap,
  Function(String)? onChange,
}) =>
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: width(context, widthSize ?? 1),
        child: TextFormField(
          onTap: onTap,
          onChanged: onChange,
          enabled: enabled,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(label: titleText(text: text)),
        ),
      ),
    );

Widget buildNewTask({
  required Map model,
  required ScreenManager screenManager,
  required int i,
  bool? fromNew = true,
  bool? fromDone,
}) =>
    Dismissible(
      key: Key(model['id'].toString()),
      direction: (!fromNew! && !fromDone!)
          ? DismissDirection.endToStart
          : DismissDirection.horizontal,
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          screenManager.updateDatabase(id: model['id'], status: 'archive');
          debugPrint('todo archived');
        } else if (direction == DismissDirection.endToStart) {
          deletedTasks.add(model);
          screenManager.deleteFromDatabase(id: model['id']);
          debugPrint('todo deleted');
        }
      },
      background: Container(
        color: BackgroundColors.semiGreyBG,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            children: [const Icon(Icons.archive), normalText(text: 'Archive')],
          ),
        ),
      ),
      secondaryBackground: Container(
        color: BackgroundColors.redBG,
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [const Icon(Icons.delete), normalText(text: 'Delete')],
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: titleText(text: '${i + 1}'),
            ),
            title: titleText(text: model['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                normalText(text: model['description']),
                normalText(text: model['date']),
              ],
            ),
            trailing: normalText(text: model['time']),
          ),
          fromNew
              ? Checkbox(
                  value: isDone[i],
                  onChanged: (value) {
                    screenManager.changeToDone(value, isDone, i);
                    screenManager.updateDatabase(
                        status: 'done', id: model[i]['id']);
                  })
              : fromDone ?? false
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.done, color: Colors.green),
                          normalText(text: 'Done', color: Colors.green),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.archive, color: Colors.grey),
                          normalText(text: 'Archived', color: Colors.grey),
                        ],
                      ),
                    ),
        ],
      ),
    );
