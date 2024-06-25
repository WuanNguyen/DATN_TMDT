import 'package:doan_tmdt/model/bottom_navigation.dart';
import 'package:doan_tmdt/screens/login/firstapp_screen.dart';
// import 'package:doan_tmdt/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const BottomNavigation(index: 0),
      home: const FirstappScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
