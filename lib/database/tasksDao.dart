import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/Network/local/cache_helper.dart';
import 'package:todo/models/task_model.dart';

class TasksDao{
  static CollectionReference<Task> getTasksCollection(){
    var db = FirebaseFirestore.instance;
    // withConvertor function is used to tell the database how to
    // make the conversion of an object to a map and vice versa
    // through the two functions we made => fromJson and toJson
    var usersTasksCollection = db.collection(Task.collectionName).doc(CacheHelper.getData(key: 'token')).collection('UserTasks').withConverter(
      fromFirestore: (snapshot , options) => Task.fromJson(snapshot.data()),
      toFirestore: (object , options) => object.toJson(),
    );
    return usersTasksCollection;
  }

  static Future<void> addTask(Task task) async {
    var usersTasksCollection = getTasksCollection().doc();
    print(usersTasksCollection.path);
      print("enter sucess");
      await usersTasksCollection.set(task).onError((error, stackTrace) => print(error.toString()));
      print("hello");


      print("Task added successfully");

    print("enter sucess 3");
  }


// static Future<List<Task?>> getTasks(String uid) async{
  //   List<Task> tasks = [];
  //   var tasksCollection = FirebaseFirestore.instance
  //       .collection('tasks')
  //       .doc(uid)
  //       .collection('userTasks');
  //   var querySnapshot = await tasksCollection.get();
  //   for (var docSnapshot in querySnapshot.docs) {
  //     var taskData = docSnapshot.data();
  //     var task = Task.fromJson(taskData);
  //     tasks.add(task);
  //   }
  //   return tasks;
  // }

}