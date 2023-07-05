import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_app/components/constants.dart';
import 'package:todo_app/screens/screens_bloc/screens_states.dart';

class ScreenManager extends Cubit<ScreenState> {
  ScreenManager() : super(InitScreenState());

  static ScreenManager screenManager(context) =>
      BlocProvider.of<ScreenManager>(context);

  late Database database;

  void createDataBase() {
    openDatabase('todoApp.db', version: 1,
        onCreate: (Database database, int version) {
      debugPrint('database created');
      // When creating the db, create the table
      database
          .execute(
              'CREATE TABLE todoList (id INTEGER PRIMARY KEY, name TEXT, description TEXT, time TEXT, date TEXT, status TEXT)')
          .then((value) {
        debugPrint('table created');
        debugPrint(' database la $database');
        emit(CreateDatabaseState());
      }).catchError((e) => throw 'zalabo2a ${e.toString()}');
      emit(CreateDatabaseState());
    }, onOpen: (database) {
      debugPrint('database opened');
      getDatabase(database);
    }).catchError((e) {
      debugPrint('moza $e');
      throw e;
    }).then((value) {
      database = value;
      emit(OpenDatabaseState());
    });
  }

  Future insertToDatabase(
      String name, String description, String time, String date) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO  todoList(name, description, time, date, status) VALUES("$name", "$description", "$time", "$date", "new")')
          .then((value) {
        debugPrint('$value INSERT SUCCESS');
        emit(InsertDatabaseState());
        return value;
      }).catchError((e) {
        debugPrint(e.toString());
        return e;
      });
    }).then((value) {
      getDatabase(database);
    });
  }

  void getDatabase(database) {
    allTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(GetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM todoList').then((value) {
      value.forEach((value) {
        if (value['status'] == 'new') {
          allTasks.add(value);
          isDone = List.generate(allTasks.length, (index) => false);
        } else if (value['status'] == 'done') {
          doneTasks.add(value);
        } else if (value['status'] == 'archive') {
          archiveTasks.add(value);
        } else {
          throw Exception('Invalid status');
        }
      });
      debugPrint('new $allTasks');
      debugPrint('done $doneTasks');
      debugPrint('archive $archiveTasks');
      debugPrint('deleted $deletedTasks');
      emit(GetDatabaseState());
    }).catchError((e) => throw 'get database from insert ${e.toString()}');
  }

  void updateDatabase({required String status, required int id}) async {
    database.rawUpdate('UPDATE todoList SET status = ? WHERE id = ?',
        [status, id]).then((value) {
      emit(UpdateDatabaseState());
      getDatabase(database);
    });
  }

  void deleteFromDatabase({required int id}) {
    database.rawDelete('DELETE FROM todoList WHERE id = ?', [id]).then((value) {
      emit(DeleteFromDatabaseState());
      getDatabase(database);
    });
  }

  ///////////////////////////Progress todo screen/////////////////////////////////////
  
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController todoName = TextEditingController();
  TextEditingController todoDesc = TextEditingController();
  TextEditingController todoDate = TextEditingController();
  TextEditingController todoTime = TextEditingController();
  Icon addFloatingButton = const Icon(Icons.edit);
  bool isBottomSheetOpened = false;

  changeFloatingIcon() {
    !isBottomSheetOpened
        ? {addFloatingButton = const Icon(Icons.edit), emit(CloseSheetState())}
        : {addFloatingButton = const Icon(Icons.add), emit(OpenSheetState())};
  }

  void changeToDone(value, isDone, index) {
    isDone[index] = true;
    emit(ChangeTaskToDoneState());
  }

  // moveToDone(index) {
  //   allTasks.removeAt(index);
  // }
  ///////////////////////////Done todo screen/////////////////////////////////////
  ///////////////////////////Archive todo screen/////////////////////////////////////
}
