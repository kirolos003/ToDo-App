import 'package:flutter/material.dart';
import 'package:todo/Network/local/cache_helper.dart';
import 'package:todo/database/tasksDao.dart';
import 'package:todo/models/task_model.dart';

class AppProvider extends ChangeNotifier {
  String isEnglish = 'ar';

  void changeAppLanguage({String? fromShared}) {
    if (fromShared != null) {
      isEnglish = fromShared;
    } else {
      isEnglish = (isEnglish == 'en') ? 'ar' : 'en';
      CacheHelper.saveData(key: 'isEnglish', value: isEnglish);
    }
    notifyListeners();
  }

  bool isDark = false;

  void changeAppTheme({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      notifyListeners();
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark)
          .then((value) => notifyListeners());
    }
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_off_outlined;
  void changeSuffixVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility;
    notifyListeners();
  }

  List<Task> tasks = [];
  DateTime selectedDate = DateTime.now();
  void getTasks({String? uid}) async {
    var tasksCollection =
        TasksDao.getTasksCollection(CacheHelper.getData(key: 'token'));
    var querySnapshot = await tasksCollection.get();
    tasks = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    notifyListeners();
    tasks = tasks.where((task) {
      if (task.time?.day == selectedDate.day &&
          task.time?.month == selectedDate.month &&
          selectedDate.year == task.time?.year) {
        return true;
      } else {
        return false;
      }
    }).toList();
    tasks.sort((Task task1, Task task2) {
      // 0 => in the compare if they are equal it will return 0
      // 1 => in the compare if the task 2 is greater than task 1 it will return 1
      // -1 => in the compare if the task 2 is greater than task 1 it will return -1
      return task1.time!.compareTo(task2.time!);
    });

    notifyListeners();
  }

  void changeDate(DateTime newDate) {
    selectedDate = newDate;
    getTasks();
  }

  static Future<void> deleteTask(Task task, String uid) {
    return TasksDao.getTasksCollection(uid)
        .doc(task.id)
        .delete()
        .timeout(const Duration(seconds: 1), onTimeout: () {});
  }

  bool taskChecked = false;

  Future<void> updateTask(Task task, String uid, {bool isDone = false}) {
    return TasksDao.getTasksCollection(uid).doc(task.id).update({
      'isDone': isDone,
      'title': task.title,
      'description': task.description,
      'time': task.time
    }).timeout(const Duration(milliseconds: 500), onTimeout: () {
      taskChecked = isDone;
      notifyListeners();
    });
  }
}
