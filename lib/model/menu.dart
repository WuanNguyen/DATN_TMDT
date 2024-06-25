import 'package:doan_tmdt/model/bottom_navigation.dart';
import 'package:doan_tmdt/screens/login/firstapp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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
                            'https://firebasestorage.googleapis.com/v0/b/tmdt-bangiay.appspot.com/o/images%2Fcat.jpg?alt=media&token=ee7848ba-9db3-4dfd-8109-7dff8eebc416',
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
                  const Text(
                    'Huan Nguyen',
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
                    builder: (context) => const BottomNavigation(index: 0)),
              );
              //Sử lí sự kiện khi click
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            title: const Row(
              children: [Icon(Icons.chat), SizedBox(width: 15), Text('Chat')],
            ),
            onTap: () {
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
