import 'package:doan_tmdt/auth/firebase_auth.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:doan_tmdt/screens/admin/admin_bottomnav.dart';
import 'package:doan_tmdt/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscureText = true;
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
  String image_url =
      "https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a";
  String address = "";

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
                                controller: password,
                                obscureText: obscureText,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w500),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscureText = !obscureText;
                                      });
                                    },
                                    icon: Icon(
                                      obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
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
                                controller: cpassword,
                                obscureText: obscureText,
                                decoration: InputDecoration(
                                  labelText: "Confirm password",
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.w500),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscureText = !obscureText;
                                      });
                                    },
                                    icon: Icon(
                                      obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
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
                              } else if (!isEmail(gmail.text)) {
                                MsgDialog.MSG(context, 'Warning',
                                    'Please enter a valid email');
                              } else {
                                // Chuẩn hóa email
                                String normalizedEmail = gmail.text;
                                if (gmail.text.endsWith('@googlemail.com')) {
                                  normalizedEmail = gmail.text.replaceAll(
                                      '@googlemail.com', '@gmail.com');
                                }

                                if (!normalizedEmail.endsWith('gmail.com')) {
                                  MsgDialog.MSG(context, 'Warning',
                                      'Email must end with "gmail.com"');
                                } else if (password.text.isEmpty) {
                                  MsgDialog.MSG(context, 'Warning',
                                      'Please enter password');
                                } else if (password.text.length < 6) {
                                  MsgDialog.MSG(context, 'Warning',
                                      'Password must be at least 6 characters long');
                                } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                    .hasMatch(password.text)) {
                                  MsgDialog.MSG(context, 'Warning',
                                      'Password must contain at least one special character');
                                } else if (cpassword.text.isEmpty) {
                                  MsgDialog.MSG(context, 'Warning',
                                      'Please enter confirm password');
                                } else if (password.text != cpassword.text) {
                                  MsgDialog.MSG(context, 'Warning',
                                      'Password confirmation failed');
                                } else {
                                  try {
                                    int atIndex = normalizedEmail.indexOf('@');
                                    fullname =
                                        normalizedEmail.substring(0, atIndex);

                                    // Kiểm tra email đã tồn tại trước khi gọi signUp
                                    List<String> signInMethods =
                                        await FirebaseAuth.instance
                                            .fetchSignInMethodsForEmail(
                                                normalizedEmail);
                                    if (signInMethods.isNotEmpty) {
                                      MsgDialog.MSG(context, 'Warning',
                                          'Email is already in use. Please use another email.');
                                    } else {
                                      _fireauth.signUp(
                                          normalizedEmail,
                                          password.text,
                                          fullname,
                                          phone,
                                          address,
                                          role,
                                          image_url,
                                          status, () {
                                        MsgDialog.notilogin(
                                            context,
                                            'Notification',
                                            'Registered successfully');
                                      }, (String errorMsg) {
                                        MsgDialog.MSG(
                                            context, 'Sign-In', errorMsg);
                                      });
                                    }
                                  } catch (e) {
                                    MsgDialog.MSG(context, 'Sign-In',
                                        'An error occurred during sign-up: $e');
                                  }
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
