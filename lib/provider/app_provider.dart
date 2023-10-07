import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/Network/local/cache_helper.dart';
import 'package:todo/database/tasksDao.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/models/users.dart' as MyUser;

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
      }
      else {
        isDark = !isDark;
        CacheHelper.saveData(key: 'isDark', value: isDark).then((value) =>
            notifyListeners()
        );
      }
    }

  bool isPassword = false;
  IconData suffix = Icons.visibility_off_outlined;
  void changeSuffixVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility;
    notifyListeners();
  }

  List<Task> tasks = [];

  void getTasks({String? uid ,DateTime? date}) async {
    var tasksCollection = TasksDao.getTasksCollection(CacheHelper.getData(key: 'token'));
    var querySnapshot = await tasksCollection.get();
    tasks = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    notifyListeners();
    if (date != null) {
      // retrievedTasks.contains(arrayContains:); // isequalto
    }
  }

  static Future<void> deleteTask(Task task , String uid) {
    return TasksDao.getTasksCollection(uid).doc(task.id).delete().timeout(Duration(seconds: 1) , onTimeout: (){
      print('finshed');
    });
  }

}

