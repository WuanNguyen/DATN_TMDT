import 'package:doan_tmdt/model/menu.dart';
import 'package:doan_tmdt/screens/admin/admin_add.dart';
import 'package:doan_tmdt/screens/admin/admin_menu.dart';
import 'package:doan_tmdt/screens/admin/admin_profile.dart';
import 'package:doan_tmdt/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AdminBottomnav extends StatefulWidget {
  final int index;
  const AdminBottomnav({super.key, required this.index});

  @override
  State<AdminBottomnav> createState() => _AdminBottomnavState();
}

class _AdminBottomnavState extends State<AdminBottomnav> {
  int _selectedIndex = 0; // Không cần sử dụng 'late' ở đây

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      HomeScreen(),
      AdminAdd(),
      // AdminListproduct(),
      AdminProfile()
    ];

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text(
          'SPORT HUVIZ',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // sự kiện icon thông báo
              },
              icon: const Icon(Icons.notifications))
        ],
        backgroundColor: const Color.fromRGBO(201, 241, 248, 1),
      ),
      drawer: const AdminMenu(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              Color.fromARGB(255, 139, 90, 238),
              Color(0xff5b0060),
              Color(0xff870160),
              Color.fromARGB(255, 235, 138, 179),
              Color(0xffca485c),
              Color(0xffe16b5c),
              Color(0xfff39060),
              Color(0xffffb56b),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: NavigationBar(
          backgroundColor: const Color.fromARGB(240, 201, 227, 239),
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemSelected,
          indicatorColor: Color.fromARGB(239, 166, 172, 174),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: ''),
            NavigationDestination(icon: Icon(Icons.add), label: ''),
            NavigationDestination(
                icon: Icon(Icons.admin_panel_settings), label: ''),
          ],
        ),
      ),
      body: Container(
        child: _screens[_selectedIndex],
      ),
    );
  }
}
