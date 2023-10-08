import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/Network/local/cache_helper.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/provider/app_provider.dart';


class TodoDetailsScreen extends StatefulWidget {
  const TodoDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TodoDetailsScreen> createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
    @override
  void initState(){
      super.initState();

    }
  @override
  Widget build(BuildContext context) {
    final Task receivedData = ModalRoute.of(context)?.settings.arguments as Task;
    AppProvider provider = Provider.of<AppProvider>(context);
    TextEditingController taskName = TextEditingController();
    TextEditingController taskDetails = TextEditingController();
    DateTime selectedDate = DateTime.now();
    Future<void> selectTime(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(
            days: 365
        )),
      );

      if (picked != null) {
        setState(() {
          selectedDate = picked;
        });
      }
    }
    var formKey = GlobalKey<FormState>();
    
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: provider.isDark ? const Color(0xff060E1E) : const Color(
                0xffDFECDB),
          ),
          child: SafeArea(
            minimum: const EdgeInsets.all(2),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update Task",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(
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
                          onChanged: (text){
                            if(text.isNotEmpty ) {
                              taskName.text = text;
                            }
                          },
                          initialValue: receivedData.title,
                          style: provider.isDark ? const TextStyle(
                              color: Colors.white) : const TextStyle(
                              color: Colors.black),
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
                              borderSide: BorderSide(color: Colors
                                  .blue),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors
                                  .grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          onChanged: (text){
                            if(text.isNotEmpty ) {
                              taskDetails.text = text;
                            }
                          },
                          initialValue: receivedData.description,
                          style: provider.isDark ? const TextStyle(
                              color: Colors.white) : const TextStyle(
                              color: Colors.black),
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
                              borderSide: BorderSide(color: Colors
                                  .blue), // Replace with your desired color
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors
                                  .grey), // Replace with your desired color
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
                              selectTime(context);
                            },
                            child: Text(
                              DateFormat('MMMM dd, yyyy').format(selectedDate),
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
                                  Task task = Task(
                                    title: taskName.text,
                                    description: taskDetails.text,
                                    time: selectedDate,
                                    id: receivedData.id,
                                  );
                                  provider.updateTask(
                                      task, CacheHelper.getData(key: 'token'));
                                  provider.getTasks();
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                "update",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium,
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
          ),
        ),
      ),
    );
  }
}



