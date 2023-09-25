import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../provider/app_provider.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

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
              itemBuilder: (context, index) => TaskWidgetBuilder(),
              itemCount: 30,
              physics: const BouncingScrollPhysics(),
            ),
          )
        ],
      ),
    );
  }
}

class TaskWidgetBuilder extends StatefulWidget {
  const TaskWidgetBuilder({Key? key}) : super(key: key);

  @override
  State<TaskWidgetBuilder> createState() => _TaskWidgetBuilderState();
}

class _TaskWidgetBuilderState extends State<TaskWidgetBuilder> {
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
                  "Play BasketBall",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: taskChecked ? const Color(0xff61E757) : Theme.of(context).primaryColor,
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.access_time , color: provider.isDark ? Colors.white : Colors.black,),
                    Text(
                      "10:20 AM",
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
