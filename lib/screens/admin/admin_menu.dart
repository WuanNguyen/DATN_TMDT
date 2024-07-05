import 'package:doan_tmdt/screens/admin/admin_bottomnav.dart';
import 'package:doan_tmdt/screens/login/firstapp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({super.key});

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  //--------------------------
  String image =
      "https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a";
  String name = "";

  //------------------
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  //------------------------
  Future<void> getUserInfo() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child(currentUser.uid);
      DataSnapshot snapshot = await userRef.once().then((DatabaseEvent event) {
        return event.snapshot;
      });
      if (snapshot.value != null) {
        Map userData = snapshot.value as Map;
        setState(() {
          name = userData['Username'] ?? '';
          image = userData['Image_Url'] ?? '';
        });
      }
    }
  }

  //--------------------
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Color.fromARGB(255, 247, 197, 194),
      child: Column(
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 194, 202, 240)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.home),
                SizedBox(width: 15),
                Text('Home'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminBottomnav(index: 0)),
              );
              //Sử lí sự kiện khi click
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.person_search),
                SizedBox(width: 15),
                Text('About')
              ],
            ),
            onTap: () {
              //Sử lí sự kiện khi click
            },
          ),
          const Spacer(),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.logout_outlined),
                SizedBox(width: 15),
                Text('Log out')
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FirstappScreen()),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
