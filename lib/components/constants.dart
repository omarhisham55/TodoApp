import 'package:flutter/material.dart';
import 'components.dart';
import 'style/color.dart';

List<Map> allTasks = [];
List<bool> isDone = [];
List<Map> doneTasks = [];
List<Map> archiveTasks = [];
List<Map> deletedTasks = [];

width(context, size) => MediaQuery.of(context).size.width * size;
height(context, size) => MediaQuery.of(context).size.height * size;

Future<String> openDatePicker(
  context,
) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2025),
  );
  String date = 'Time';
  if (pickedDate != null) {
    date = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
  } else {
    date = 'Time';
  }
  return date;
}

Future<String> openTimePicker(context) async {
  TimeOfDay? pickedTime =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
  return pickedTime!.format(context);
}

Widget bottomFormSheet(
        {required GlobalKey key,
        required BuildContext context,
        required TextEditingController todoName,
        required TextEditingController todoDesc,
        required TextEditingController todoDate,
        required TextEditingController todoTime}) =>
    Container(
      color: BackgroundColors.semiGreyBG,
      child: Form(
        key: key,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              addTextFeild(
                  context: context,
                  widthSize: 1,
                  text: 'Todo Name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Todo Name is required';
                    }
                    return null;
                  },
                  controller: todoName),
              addTextFeild(
                  context: context,
                  text: "Todo Description",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Todo Description is required";
                    }
                    return null;
                  },
                  controller: todoDesc),
              Row(
                children: [
                  addTextFeild(
                      context: context,
                      text: 'Date',
                      widthSize: .4,
                      onTap: () {
                        return openDatePicker(context)
                            .then((value) => todoDate.text = value)
                            .catchError((e) => throw 'from openDatePicker $e');
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Todo date is required";
                        }
                        return null;
                      },
                      controller: todoDate),
                  addTextFeild(
                      context: context,
                      text: 'Time',
                      widthSize: .3,
                      onTap: () {
                        return openTimePicker(context)
                            .then((value) => todoTime.text = value)
                            .catchError((e) => throw 'from openTimePicker $e');
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Todo time is required";
                        }
                        return null;
                      },
                      controller: todoTime),
                ],
              ),
            ],
          ),
        ),
      ),
    );
