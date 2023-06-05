import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetTask extends StatefulWidget {
  final String documentId;

  GetTask({required this.documentId});

  @override
  State<GetTask> createState() => _GetTaskState();
}

class _GetTaskState extends State<GetTask> {
  @override
  Widget build(BuildContext context) {
    CollectionReference task = FirebaseFirestore.instance.collection('tasks');
    return FutureBuilder<DocumentSnapshot>(
        future: task.doc(widget.documentId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String description = data['task description'].toString();
            return Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: Offset(2, 2))
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['task title'],
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                            child: Text(
                              description,
                              style: GoogleFonts.poppins(
                                  color: Colors.grey, fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                  'assets/watch.png',
                                  width: 25,
                                  height: 25,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 4),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.green[400],
                                ),
                                child: Text(data["begining"],
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.white)),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 4),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.red[400],
                                ),
                                child: Text(data["end"],
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Checkbox(
                    activeColor: Colors.black,
                    value: data['completed'],
                    onChanged: (bool? value) {
                      setState(() {
                        data['completed'] = value;
                        task.doc(widget.documentId).update(data);
                      });
                    },
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("Loading ..."),
              tileColor: Colors.grey[200],
            ),
          );
        });
  }

  showInfo(BuildContext context, Map<String, dynamic> data){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(data['task title'],style: GoogleFonts.poppins(),),
            content: Text(data['task description'],style: GoogleFonts.poppins(),),
            actions: [
              TextButton(
                  onPressed: (){ Navigator.pop(context); },
                  child: Text("close", style: GoogleFonts.poppins(),))
            ],
          );
        }
    );
  }
}
