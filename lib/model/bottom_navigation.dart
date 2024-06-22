import 'package:doan_tmdt/screens/cart_screen.dart';
import 'package:doan_tmdt/screens/categories_screen.dart';
import 'package:doan_tmdt/screens/home_screen.dart';
import 'package:doan_tmdt/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

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

    return Scaffold(
        appBar: AppBar(
          title: Text('MuHviz'),
        ),
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
            backgroundColor: Color.fromARGB(200, 201, 227, 239),
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemSelected,
            indicatorColor: Color.fromARGB(255, 179, 184, 188),
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
          //color: const Color.fromARGB(255, 19, 118, 185),
          child: _screens[_selectedIndex],
        ));
  }
}
