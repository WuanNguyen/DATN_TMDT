import 'package:doan_tmdt/screens/admin/admin_profileitem/admin_confirm.dart';
import 'package:doan_tmdt/screens/admin/admin_profileitem/admin_statistics.dart';
import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          const SizedBox(
            height: 20,
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
            'Admin',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.5,
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
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminConfirm()),
                        );
                      },
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.hourglass_bottom,
                              color: Colors.black,
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Comfirm',
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
                              builder: (context) => const AdminStatistics()),
                        );
                      },
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.show_chart,
                              color: Colors.black,
                            ),
                            SizedBox(width: 50),
                            Text(
                              'statistics',
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
