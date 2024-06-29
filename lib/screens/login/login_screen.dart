import 'package:doan_tmdt/auth/firebase_auth.dart';
import 'package:doan_tmdt/model/bottom_navigation.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:doan_tmdt/screens/admin/admin_bottomnav.dart';
import 'package:doan_tmdt/screens/login/firstapp_screen.dart';
import 'package:doan_tmdt/screens/login/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _fireauth = FirebAuth();
  final TextEditingController gmail = TextEditingController();
  final TextEditingController password = TextEditingController();
  //--------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FirstappScreen()),
              );
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
                        'Log in',
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
                                obscureText: true,
                                decoration: InputDecoration(
                                  label: Text(
                                    "Password",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
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
                              'Log in',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            onPressed: () {
                              try {
                                _fireauth.signIn(
                                  gmail.text,
                                  password.text,
                                  () async {
                                    User? currentUser =
                                        FirebaseAuth.instance.currentUser;
                                    if (currentUser != null) {
                                      // Lấy thông tin người dùng từ Firebase Realtime Database
                                      DatabaseReference userRef =
                                          FirebaseDatabase.instance
                                              .reference()
                                              .child('Users')
                                              .child(currentUser.uid);
                                      DataSnapshot snapshot = await userRef
                                          .once()
                                          .then((DatabaseEvent event) {
                                        return event.snapshot;
                                      });

                                      if (snapshot.value != null) {
                                        Map userData = snapshot.value as Map;
                                        String role = userData['Role'];

                                        if (role == 'admin') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminBottomnav(index: 0)),
                                          );
                                        } else if (role == 'user') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomNavigation(index: 0)),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  (mss) {
                                    MsgDialog.MSG(context, 'Sign-In', mss);
                                  },
                                );
                              } catch (err) {
                                print('Error during sign-in: $err');
                                MsgDialog.ShowDialog(context, 'Sign-In',
                                    'Login failed. Please try again later');
                              }

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           const BottomNavigation(index: 0)),
                              // );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const BottomNavigation(index: 1)));
                              },
                              child: const Text(
                                "Forgot password ?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ]),
                      const SizedBox(
                        height: 13,
                      ),
                      const Text('____________ Or ontinute with ____________'),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/img/facebook.png',
                                    height: 40,
                                    width: 40,
                                  )
                                ],
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/img/google.png',
                                    height: 40,
                                    width: 40,
                                  )
                                ],
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
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
                                            const RegisterScreen()));
                              },
                              child: const Text(
                                "Don't have an account ?",
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
