import 'package:doan_tmdt/auth/firebase_auth.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:doan_tmdt/screens/admin/admin_bottomnav.dart';
import 'package:doan_tmdt/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //final Register _register = Register();
//------------------------------
  var _fireauth = FirebAuth();
  final TextEditingController gmail = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();
  String TBEmail = "";
  String TBPassword = "";
  String TBCPassword = "";
  //
  String phone = "";
  String fullname = "";
  String role = "user";
  String image_url = "";
  int status = 0;
  //-----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Color.fromRGBO(201, 241, 248, 1),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.8, 1],
                    colors: <Color>[
                      Color.fromRGBO(201, 241, 248, 1),
                      Color.fromRGBO(231, 230, 233, 1),
                      Color.fromRGBO(231, 227, 230, 1),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/logoapp.png',
                        height: 200,
                        width: MediaQuery.of(context).size.width / 1.5,
                      ),
                      const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // SizedBox(
                      //     width: MediaQuery.of(context).size.width / 1.3,
                      //     child: const Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         TextField(
                      //           //controller: password,
                      //           controller: null,
                      //           obscureText: false,
                      //           decoration: InputDecoration(
                      //               label: Text("Name",
                      //                   style: TextStyle(
                      //                       fontWeight: FontWeight.w500))),
                      //         ),
                      //       ],
                      //     )),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                //controller: password,
                                controller: gmail,
                                obscureText: false,
                                decoration: InputDecoration(
                                    label: Text("Gmail",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                //controller: password,
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                    label: Text("Password",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                //controller: password,
                                controller: cpassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                    label: Text("Confirm password",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(150, 50),
                                elevation: 8,
                                shadowColor: Colors.white),
                            child: const Text(
                              'Sign up',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            onPressed: () async {
                              if (gmail.text.isEmpty) {
                                MsgDialog.MSG(
                                    context, 'Warning', 'Please enter gmail');
                              } else if (password.text.isEmpty) {
                                MsgDialog.MSG(context, 'Warning',
                                    'Please enter password');
                              } else if (cpassword.text.isEmpty) {
                                MsgDialog.MSG(context, 'Warning',
                                    'Please enter confirm password');
                              } else if (password.text != cpassword.text) {
                                MsgDialog.MSG(context, 'Warning',
                                    'Password confirmation failed');
                              } else {
                                // cắt gmail để lấy tên
                                int atIndex = gmail.text.indexOf('@');
                                fullname = gmail.text.substring(0, atIndex);
                                try {
                                  _fireauth.signUp(
                                      gmail.text,
                                      password.text,
                                      fullname,
                                      phone,
                                      role,
                                      image_url,
                                      status, () {
                                    MsgDialog.notilogin(context, 'Notification',
                                        'Registered successfully');
                                  }, (MSG) {});
                                } catch (e) {
                                  MsgDialog.MSG(context, 'Sign-In',
                                      'An error occurred during sign-up: $e');
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 90,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                              child: const Text(
                                "You already have an account ?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
