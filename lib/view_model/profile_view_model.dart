import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ProfileViewModel extends ChangeNotifier {

  CollectionReference user = FirebaseFirestore.instance.collection("Users");
  var userInfo = {};
  var isLoading = false;
  var passwordObscured = true;
  var passwordConfObscured = true;

  String firstName = "Loading ...";
  String lastName = "Loading ...";
  String age = "Loading ...";
  String workingPosition = "Loading ...";
  String email = "Loading ...";
  String password = "Loading ...";
  String oldPassword = "";

  Future<void> getUserDetail(String userId) async {
    isLoading = true;
    notifyListeners();
    var result = await user.doc(userId).get();
    userInfo = result.data() as Map<String, dynamic>;
    parseData();
    isLoading = false;
    notifyListeners();
  }

  void parseData(){
    firstName = userInfo["first name"];
    lastName = userInfo["last name"];
    age = userInfo["age"].toString();
    workingPosition = userInfo["work position"];
    email = userInfo["email"];
    password = userInfo["password"];
    oldPassword = password;
  }

  Future<void> editUser(String userId, String firstName, String lastName, String email,
      String password, String age) async {
    isLoading = true;
    notifyListeners();
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: oldPassword,
      );
      try {
        await currentUser.reauthenticateWithCredential(credential);
        await currentUser.updateEmail(email);
        await currentUser.updatePassword(password);
        user.doc(userId).update({
          'first name': firstName.trim(),
          'last name': lastName.trim(),
          'email': email.trim(),
          'password': password.trim(),
          'age': int.parse(age.trim()),
        });
      } catch (error) {
        print('Error reAuthenticating user: $error');
      }
    }
    getUserDetail(userId);
    isLoading = false;
    notifyListeners();
  }

  void passwordChange(){
    passwordObscured = !passwordObscured;
    notifyListeners();
  }

  void passwordConfChange(){
    passwordConfObscured = !passwordConfObscured;
    notifyListeners();
  }

}
