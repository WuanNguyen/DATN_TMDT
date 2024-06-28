import 'package:doan_tmdt/model/bottom_navigation.dart';
import 'package:doan_tmdt/screens/profile_items/address.dart';
import 'package:doan_tmdt/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit profile',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color.fromRGBO(201, 241, 248, 1),
        ),
        body: SingleChildScrollView(
          child: Container(
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
            child: Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/tmdt-bangiay.appspot.com/o/images%2Fcat.jpg?alt=media&token=ee7848ba-9db3-4dfd-8109-7dff8eebc416',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 24,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // Add your edit action here
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          //controller: password,
                          controller: null,
                          obscureText: true,
                          decoration: InputDecoration(
                              label: Text('name',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    )),
                const SizedBox(height: 15),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          //controller: password,
                          controller: null,
                          obscureText: true,
                          decoration: InputDecoration(
                              label: Text("Address",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    )),
                const SizedBox(height: 15),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          //controller: password,
                          controller: null,
                          obscureText: true,
                          decoration: InputDecoration(
                              label: Text("Phone",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    )),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          elevation: 8,
                          shadowColor: Colors.white),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BottomNavigation(index: 3)),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
