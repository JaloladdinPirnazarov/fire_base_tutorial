import 'package:fire_base_tutorial/ui/pages/login_page.dart';
import 'package:fire_base_tutorial/ui/auth/main_page.dart';
import 'package:fire_base_tutorial/view_model/profile_view_model.dart';
import 'package:fire_base_tutorial/view_model/tasks_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (create) => ProfileViewModel()),
    ChangeNotifierProvider(create: (create)=>TasksViewModel()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
