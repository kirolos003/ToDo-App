import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/FireBase/firebase_utils.dart';
import 'package:todo/UI/screens/Todos/list_screen.dart';
import 'package:todo/UI/screens/Settings/settings_screen.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/provider/app_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    TaskListScreen(),
    SettingsScreen(),
  ];

  void changeBottomNav(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TO Do List",
          textAlign: TextAlign.left,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomAppBar(
        color: provider.isDark ? const Color(0xff141A2E) : Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Theme(
          data: provider.isDark
              ? Theme.of(context).copyWith(canvasColor: const Color(0xff141A2E))
              : Theme.of(context)
                  .copyWith(canvasColor: Colors.white),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
            ],
            currentIndex: currentIndex,
            iconSize: 35,
            onTap: changeBottomNav,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(
          side: BorderSide(
            color: provider.isDark ? const Color(0xff141A2E) : const Color(0xffDFECDB),
            width: 4,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          addTaskBottomSheet();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void addTaskBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => const AddTaskBottomSheet());
  }
}

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDetails = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  var formKey = GlobalKey<FormState>();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: provider.isDark ? const Color(0xff141922) : const Color(0xffDFECDB),
      ),
      padding: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Add new Task",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: provider.isDark ? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black),
                    controller: taskName,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Task Title cannot be Empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your Task",
                      hintStyle: TextStyle(
                        color: provider.isDark
                            ? Colors.white
                            : const Color(0xff141922),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue), // Replace with your desired color
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey), // Replace with your desired color
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    style: provider.isDark ? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black),
                    controller: taskDetails,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Task Details cannot be Empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your Task Details",
                      hintStyle: TextStyle(
                        color: provider.isDark
                            ? Colors.white
                            : const Color(0xff141922),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue), // Replace with your desired color
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey), // Replace with your desired color
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Select Time",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: Text(
                        selectedTime.format(context),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffA9A9A9)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            Task task = Task(title: taskName.toString(), description: taskDetails.toString(), time: selectedTime as DateTime);
                            FirebaseUtils.addTasksToFireStore(task).timeout(Duration(milliseconds: 500) , onTimeout: (){
                              print("todo added successfully");
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Add",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
