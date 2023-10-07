import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  static const String collectionName= 'tasks';
  String? id;
  String? title;
  String? description;
  DateTime? time;
  bool? isDone;

  Task(
      {this.id = '',
      required this.title,
      required this.description,
      required this.time,
      this.isDone = false});

  // This function is used to take an object and convert it to a Map to send it to the fireStore as it understands Maps only
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'isDone': isDone,
    };
  }

  // This function is used to take a Map and convert it to a object
  // Task.fromJson(Map<String, dynamic>? json) {
  //   id = json?['id'] as String;
  //   title = json?['title'] as String;
  //   description = json?['description'] as String;
  //   time = DateTime.fromMillisecondsSinceEpoch(json?['time']);
  //   isDone = json?['isDone'] as bool;
  // }


  factory Task.fromJson(Map<String, dynamic>? json) {
    return Task(
        id : json?['id'],
        title: json?['title'],
        description: json?['description'],
        time: (json?['time'] as Timestamp).toDate(),
        isDone : json?['isDone'] as bool,
    );
  }
}


