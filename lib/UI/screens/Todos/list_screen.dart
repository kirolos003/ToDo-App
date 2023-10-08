import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/Network/local/cache_helper.dart';
import 'package:todo/UI/screens/Todos_Details/todo_details.dart';
import 'package:todo/models/task_model.dart';
import '../../../provider/app_provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    AppProvider provider = Provider.of<AppProvider>(context, listen: false);
    if (provider.tasks.isEmpty || provider.selectedDate != DateTime.now()) {
      provider.changeDate(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color:
            provider.isDark ? const Color(0xff060E1E) : const Color(0xffDFECDB),
      ),
      child: Column(
        children: [
          CalendarTimeline(
            initialDate: provider.selectedDate,
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onDateSelected: (date) {
              provider.changeDate(date);
            },
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
              itemBuilder: (context, index) =>
                  TaskWidgetBuilder(task: provider.tasks[index]),
              itemCount: provider.tasks.length,
              physics: const BouncingScrollPhysics(),
            ),
          )
        ],
      ),
    );
  }
}

class TaskWidgetBuilder extends StatefulWidget {
  final Task task;
  const TaskWidgetBuilder({Key? key, required this.task}) : super(key: key);

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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                AppProvider.deleteTask(task, CacheHelper.getData(key: 'token'));
                provider.getTasks();
                print(provider.tasks);
              },
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoDetailsScreen(),
                settings: RouteSettings(
                  arguments: task,
                ),
              ),
            );
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: provider.isDark ? const Color(0xff141922) : Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  margin: provider.isEnglish == 'en'
                      ? EdgeInsets.only(right: 20)
                      : EdgeInsets.only(left: 20),
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
                      task.title ?? '',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: taskChecked
                                ? const Color(0xff61E757)
                                : Theme.of(context).primaryColor,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: provider.isDark ? Colors.white : Colors.black,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          // "${task.time!.day}/${task.time!.month!}/${task.time!.year!}",
                          "${task.time!.hour! > 12 ? task.time!.hour! - 12 : task.time!.hour!} : ${task.time!.minute!}",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color: provider.isDark
                                      ? Colors.white
                                      : Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    taskChecked = !taskChecked;
                    provider.updateTask(task, task.id ?? '',
                        isDone: taskChecked);
                    provider.getTasks();
                    print("updated with : $taskChecked");
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
        ),
      ),
    );
  }
}
