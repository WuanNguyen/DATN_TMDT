import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                    const SizedBox(
                      height: 30,
                    ),
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
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Huan Nguyen',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(195, 208, 206, 206),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: Center(
                  child: Column(
                children: [
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {},
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            'Favorites List',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {},
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            'Address',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {},
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.history_rounded,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            'Order history',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ),
          )
        ],
      ),
    );
  }
}
