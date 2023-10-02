import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/models/task_model.dart';

class FirebaseUtils{
  static CollectionReference<Task> getTasksCollection(){
    return FirebaseFirestore.instance.collection('tasks').withConverter<Task>(
        fromFirestore: (snapshot, options) => Task.fromJson(snapshot.data()!),
        toFirestore: (task , options) => task.toJson()
    );
  }
  static Future<void> addTasksToFireStore(Task task)async {
    var taskCollection = getTasksCollection();
    var document = taskCollection.doc();
    task.id = document.id;
    document.set(task);
  }

}