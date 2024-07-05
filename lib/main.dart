import 'package:doan_tmdt/model/bottom_navigation.dart';
import 'package:doan_tmdt/screens/admin/admin_add.dart';
import 'package:doan_tmdt/screens/login/firstapp_screen.dart';
import 'package:doan_tmdt/screens/search_screen.dart';
import 'package:doan_tmdt/textdata.dart';
import 'package:doan_tmdt/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:doan_tmdt/screens/about_us.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      //home: const BottomNavigation(index: 1),
      //home: const FirstappScreen(),
      home:AboutUs(),
      //home: ShowData(data1: '', data2: '', data3: '', data4: ''),
      //home: AdminAdd(),

      debugShowCheckedModeBanner: false,
    );
  }
}
