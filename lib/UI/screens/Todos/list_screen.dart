import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/Network/local/cache_helper.dart';
import 'package:todo/database/tasksDao.dart';
import 'package:todo/models/task_model.dart';

import '../../../provider/app_provider.dart';

class TaskListScreen extends StatefulWidget {

  TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
   static List<Task> tasks = [];
   void initState() {
     super.initState();
     getTasks(CacheHelper.getData(key: 'token'));
     print(tasks);
   }
  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color:provider.isDark ? const Color(0xff060E1E) : const Color(0xffDFECDB),
      ),
      child: Column(
        children: [
          CalendarTimeline(
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onDateSelected: (date) => () {},
            leftMargin: 30,
            monthColor: provider.isDark ? Colors.white : Colors.black,
            dayColor: provider.isDark ? Colors.white : Colors.black,
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Theme.of(context).primaryColor,
            dotsColor: Colors.white,
            selectableDayPredicate: (date) => true,
            locale: 'en_ISO',
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => TaskWidgetBuilder(task : tasks[index]),
              itemCount: tasks.length,
              physics: const BouncingScrollPhysics(),
            ),
          )
        ],
      ),
    );
  }

   void getTasks(String uid) async {
     try {
       var tasksCollection = FirebaseFirestore.instance
           .collection('tasks')
           .doc(uid)
           .collection('userTasks');
       var querySnapshot = await tasksCollection.get();
       var retrievedTasks = querySnapshot.docs.map((doc) {
         return Task.fromJson(doc.data());
       }).toList();
       setState(() {
         print(retrievedTasks);
         tasks = retrievedTasks;
       });
     } catch (error) {
       print("Error fetching tasks: $error");
     }
   }
}

class TaskWidgetBuilder extends StatefulWidget {
  final Task task;
  const TaskWidgetBuilder({Key? key  , required this.task}) : super(key: key);

  @override
  State<TaskWidgetBuilder> createState() => _TaskWidgetBuilderState(task: task);
}

class _TaskWidgetBuilderState extends State<TaskWidgetBuilder> {
  final Task task;
  _TaskWidgetBuilderState({required this.task});
  bool taskChecked = false;
  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context);
    return Slidable(
      startActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {},
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15)
            ),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: provider.isDark ? const Color(0xff141922) : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              height: 80,
              width: 6,
              color: taskChecked
                  ? const Color(0xff61E757)
                  : Theme.of(context).primaryColor,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title??'',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: taskChecked ? const Color(0xff61E757) : Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.access_time , color: provider.isDark ? Colors.white : Colors.black,),
                    Text(
                      "${task.time!}",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: provider.isDark ? Colors.white : Colors.black
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                setState(() {
                  taskChecked = !taskChecked;
                });
              },
              child: taskChecked
                  ? Text(
                "Done !",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: const Color(0xff61E757)),
              )
                  : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }

}
