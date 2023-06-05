import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base_tutorial/read_data/get_user_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  List<String> docIDs = [];
  late Future<void> docIdFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    docIdFuture = getDocId();
  }

  Future<void> getDocId() async {
    docIDs.clear();
    await FirebaseFirestore.instance
        .collection('Users')
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Signed in as\n${user!.email}",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          MaterialButton(
            child: Text(
              "Log out",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            color: Colors.deepPurple[200],
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          const SizedBox(
            height: 15,
          ),          Expanded(
            child: FutureBuilder<void>(
              future: docIdFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'),);
                } else {
                  return ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, position) {
                      return GetUserName(documentId: docIDs[position]);
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
}
