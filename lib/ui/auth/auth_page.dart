import 'package:fire_base_tutorial/ui/pages/login_page.dart';
import 'package:fire_base_tutorial/ui/pages/register_page.dart';
import 'package:flutter/cupertino.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool sowLoginPage = false;

  void toggleScreens() {
    setState(() {
      print("SetState");
      sowLoginPage = !sowLoginPage;
      print("sowLoginPage: $sowLoginPage");
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginPage(showregisterPage: toggleScreens);
    // return sowLoginPage
    //     ? LoginPage(showregisterPage: toggleScreens)
    //     : RegisterPage(showLoginPage: toggleScreens);
  }
}
