import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:doan_tmdt/screens/profile_items/edit_profile.dart';
import 'package:doan_tmdt/screens/profile_items/favorites_list.dart';
import 'package:doan_tmdt/screens/profile_items/order_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
  //--------------------

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

  //--------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        image,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    name,
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(195, 199, 197, 197),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile()),
                        );
                      },
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Edit Profile',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FavoritesList()),
                        );
                      },
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.black,
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Favorites List',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrderHistory()),
                        );
                      },
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.history_rounded,
                              color: Colors.black,
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Order history',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        MsgDialog.MsgDeleteAccount(context, 'Notification',
                            'Are you sure to delete your account ?');
                      },
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Lock account',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
