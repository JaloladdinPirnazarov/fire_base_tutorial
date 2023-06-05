import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base_tutorial/read_data/get_task.dart';
import 'package:fire_base_tutorial/ui/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  List<String> docIDs = [];
  QueryDocumentSnapshot<Map<String, dynamic>>? userInfo;
  late Future<void> docIdFuture;
  String date = DateFormat('dd.MM.yyyy').format(DateTime.now());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    docIdFuture = getDocId();
  }

  Future<void> getDocId() async {
    docIDs.clear();

    await FirebaseFirestore.instance
        .collection("Users")
        .where('email', isEqualTo: user!.email!)
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              setState(() {
                userInfo = element;
              });
              print("element: ${element.data()}");
            }));

    print("userId length: ${userInfo!.data()}");

    await FirebaseFirestore.instance
        .collection('tasks')
        .where('user email', isEqualTo: user!.email!)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
    print("Document count: ${docIDs.length}");
  }

  @override
  Widget build(BuildContext context) {
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
          date,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
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
                                    userId: userInfo!.id,
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
                            userInfo == null
                                ? "Loading ..."
                                : "${userInfo!.data()['first name']} ${userInfo!.data()['last name']}",
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
                                    userId: userInfo!.id,
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
            child: FutureBuilder<void>(
              future: docIdFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, position) {
                      return GetTask(documentId: docIDs[position]);
                    },
                  );
                }
              },
            ),
          ),
        ],
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
