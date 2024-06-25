import 'package:doan_tmdt/screens/login/login_screen.dart';
import 'package:doan_tmdt/screens/login/register_screen.dart';
import 'package:flutter/material.dart';

class FirstappScreen extends StatefulWidget {
  const FirstappScreen({super.key});

  @override
  State<FirstappScreen> createState() => _FirstappScreenState();
}

class _FirstappScreenState extends State<FirstappScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const SizedBox(
                    height: 105,
                  ),
                  Image.asset(
                    'assets/img/logoapp.png',
                    height: 200,
                    width: MediaQuery.of(context).size.width / 1.5,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 116, 163, 189),
                    ),
                  ),
                  const SizedBox(
                    height: 150,
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
                          'Sign in',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            elevation: 8,
                            shadowColor: Colors.white),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
