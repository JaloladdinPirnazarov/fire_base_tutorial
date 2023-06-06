import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class TasksViewModel extends ChangeNotifier{
  final user = FirebaseAuth.instance.currentUser;
  QueryDocumentSnapshot<Map<String, dynamic>>? userInfo;
  List<String> docIDs = [];
  bool isLoading = false;
  String date = "Loading ...";



  Future<void>getData(String currentDate)async{
    isLoading = true;
    notifyListeners();
    date = currentDate;
    await FirebaseFirestore.instance
        .collection("Users")
        .where('email', isEqualTo: user!.email!)
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
      userInfo = element;
      print("element: ${element.data()}");
    }));
    await FirebaseFirestore.instance
        .collection('tasks')
        .where('user email', isEqualTo: user!.email!)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
      print(document.reference);
      docIDs.add(document.reference.id);
    }));
    isLoading = false;
    notifyListeners();
  }
}