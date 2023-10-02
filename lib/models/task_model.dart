class Task {
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
  Map<String,dynamic> toJson(){
    return{
      'id' : id,
      'title' : title,
      'description' : description,
      'time' : time?.millisecondsSinceEpoch,
      'isDone' : isDone,
    };
  }

  // This function is used to take a Map and convert it to a object
  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    title = json['title'] as String;
    description = json['description'] as String;
    time = DateTime.fromMillisecondsSinceEpoch(json['time']);
    isDone = json['isDone'] as bool;
  }
}