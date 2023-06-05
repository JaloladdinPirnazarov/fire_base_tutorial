import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showregisterPage;

  const LoginPage({Key? key, required this.showregisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = true;

  Future signIn() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.android,
                  size: 100,
                ),
                const SizedBox(
                  height: 90,
                ),
                Text(
                  "Hello There",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 36),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Register bellow with your details!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 20),
                ),
                const SizedBox(
                  height: 50,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: _emailController,
                        style: GoogleFonts.poppins(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: _passwordController,
                        style: GoogleFonts.poppins(),
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          hintStyle: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordPage()));
                        },
                        child: Text(
                          "Forgot password?",
                          style: GoogleFonts.poppins(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 60,
                ),

                InkWell(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.deepPurple[200]),
                    child: Center(
                        child: Text(
                      "Sign in",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member? ",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: widget.showregisterPage,
                      child: Text(
                        "Register now",
                        style: GoogleFonts.poppins(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),

                // not a member register now
              ],
            ),
          ),
        ),
      ),
    );
  }
}
