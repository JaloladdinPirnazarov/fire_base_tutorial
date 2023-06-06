import 'package:fire_base_tutorial/view_model/profile_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  String userId;

  Profile({required this.userId, super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _workPosition = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _workPosition.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<ProfileViewModel>().getUserDetail(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.grey[300],
          title: Text(
            "Profile",
            style: GoogleFonts.poppins(
                fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<ProfileViewModel>(
          builder: (context, value, child) {
            if (!context.watch<ProfileViewModel>().isLoading) {
              var watch = context.watch<ProfileViewModel>();
              var read = context.read<ProfileViewModel>();
              _firstNameController.text = watch.firstName;
              _lastNameController.text = watch.lastName;
              _ageController.text = watch.age;
              _workPosition.text = watch.workingPosition;
              _emailController.text = watch.email;
              _passwordController.text = watch.password;
              _passwordConfController.text = watch.password;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          padding: EdgeInsets.only(bottom: 5),
                          color: Colors.grey[200],
                        ),
                        Container(
                          color: Colors.white,
                          height: 40,
                        ),
                        Positioned(
                          //left: (MediaQuery.of(context).size.width - 70) / 2,
                          top: (MediaQuery.of(context).size.height * 0.15) - 70,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[350]),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
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
                            controller: _firstNameController,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'First name',
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
                            controller: _lastNameController,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Last name',
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
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _ageController,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Age',
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
                            readOnly: true,
                            keyboardType: TextInputType.emailAddress,
                            controller: _workPosition,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Work position',
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
                            keyboardType: TextInputType.emailAddress,
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
                            obscureText: watch.passwordObscured,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              hintStyle: GoogleFonts.poppins(),
                              suffixIcon: IconButton(
                                icon: Icon(watch.passwordObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: read.passwordChange,
                              ),
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
                            controller: _passwordConfController,
                            style: GoogleFonts.poppins(),
                            obscureText: watch.passwordConfObscured,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm password',
                              suffixIcon: IconButton(
                                icon: Icon(watch.passwordConfObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: read.passwordConfChange,
                              ),
                              hintStyle: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (detailConfirmed() && passwordConfirmed()) {
                          read.editUser(
                            widget.userId,
                            _firstNameController.text,
                            _lastNameController.text,
                            _emailController.text,
                            _passwordController.text,
                            _ageController.text,
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 22),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.deepPurple),
                        child: Center(
                            child: Text(
                          "Edit profile",
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
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  bool detailConfirmed() {
    return _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty;
  }

  bool passwordConfirmed() {
    return _passwordConfController.text.isNotEmpty &&
        _passwordController.text == _passwordConfController.text;
  }
}
