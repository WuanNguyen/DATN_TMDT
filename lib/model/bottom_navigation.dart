import 'package:doan_tmdt/model/menu.dart';
import 'package:doan_tmdt/screens/cart_screen.dart';
import 'package:doan_tmdt/screens/categories_screen.dart';
import 'package:doan_tmdt/screens/home_items/notification_screen.dart';
import 'package:doan_tmdt/screens/home_screen.dart';
import 'package:doan_tmdt/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key, required this.index});
  final int index;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _selectedIndex;

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
      CategoriesScreen(),
      CartScreen(),
      ProfileScreen()
    ];

    // Danh sách màu cho từng màn hình
    // List<Color> _indicatorColors = [
    //   Colors.blue, // Màu cho HomeScreen
    //   Colors.green, // Màu cho CategoriesScreen
    //   Colors.orange, // Màu cho CartScreen
    //   Colors.purple, // Màu cho ProfileScreen
    // ];

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
                // sự kiện icon thông báo
              },
              icon: const Icon(Icons.notifications))
        ],
        backgroundColor: const Color.fromRGBO(201, 241, 248, 1),
      ),
      drawer: const Menu(),
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
            NavigationDestination(
                icon: Icon(Icons.format_list_bulleted_sharp), label: ''),
            NavigationDestination(
                icon: Icon(Icons.shopping_cart_rounded), label: ''),
            NavigationDestination(icon: Icon(Icons.person), label: ''),
          ],
        ),
      ),
      body: Container(
        child: _screens[_selectedIndex],
      ),
    );
  }
}
