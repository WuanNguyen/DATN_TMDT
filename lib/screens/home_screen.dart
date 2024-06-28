import 'package:doan_tmdt/model/product.dart';
import 'package:doan_tmdt/screens/home_items/collection.dart';
import 'package:doan_tmdt/screens/home_items/product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(130, 255, 255, 255),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Search',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        // Implement clear functionality
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Collection(name: "ELEMENT COLLECTION"),
                    ProductList(genre: "MALE"),
                    ProductList(genre: "FEMALE"),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
