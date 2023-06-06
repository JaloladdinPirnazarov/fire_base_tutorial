import 'package:fire_base_tutorial/read_data/get_task.dart';
import 'package:fire_base_tutorial/ui/pages/profile.dart';
import 'package:fire_base_tutorial/view_model/tasks_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  String date = DateFormat('dd.MM.yyyy').format(DateTime.now());

  @override
  void initState() {
    context.read<TasksViewModel>().getData(date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var watch = context.watch<TasksViewModel>();
    var read = context.read<TasksViewModel>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[300],
        actions: [
          IconButton(
              onPressed: () {
                datePicker(context);
              },
              icon: Icon(
                Icons.calendar_month,
                color: Colors.grey,
              ))
        ],
        title: Text(
          context.watch<TasksViewModel>().date,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<TasksViewModel>(
        builder: (context, value, child){
          if(value.isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          else{ return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile(
                                    userId: watch.userInfo!.id,
                                  )));
                        },
                        child: SizedBox(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[350]),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                              Text(
                                watch.userInfo == null
                                    ? "Loading ..."
                                    : "${watch.userInfo!.data()['first name']} ${watch.userInfo!.data()['last name']}",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuButton(
                        child: Icon(
                          Icons.more_vert_outlined,
                          color: Colors.grey,
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Edit",
                                  style: GoogleFonts.poppins(),
                                )
                              ],
                            ),
                            value: "edit",
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Log out",
                                  style: GoogleFonts.poppins(),
                                )
                              ],
                            ),
                            value: "logout",
                          ),
                        ],
                        onSelected: (value) {
                          if (value == "edit") {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile(
                                    userId: watch.userInfo!.id,
                                  )),
                            );
                          } else if (value == "logout") {
                            //Navigator.pop(context);
                            warningDialog(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: watch.docIDs.length,
                  itemBuilder: (context, position) {
                    return GetTask(documentId: watch.docIDs[position]);
                  },
                )
              ),
            ],
          ); }
        },
      ),
    );
  }

  Future<void> datePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != date) {
      setState(() {
        date = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  warningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Warning",
              style: GoogleFonts.poppins(),
            ),
            content: Text(
              "Are you sure that you want to log out?",
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseAuth.instance.signOut();
                  },
                  child: Text(
                    "Yes",
                    style: GoogleFonts.poppins(),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No",
                    style: GoogleFonts.poppins(),
                  )),
            ],
          );
        });
  }
}
