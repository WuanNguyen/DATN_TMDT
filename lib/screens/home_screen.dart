import 'package:doan_tmdt/model/product.dart';
import 'package:doan_tmdt/screens/home_items/collection.dart';
import 'package:doan_tmdt/screens/home_items/product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(//! tran man hinh, fix searchbar
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(50)
          ),
          child:  SearchBar(
            leading: Icon(Icons.search),
            padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.fromLTRB(20, 0, 0, 0)),
          ),
        ),
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 192,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Collection(name:"ELEMENT COLLECTION"),
                  ProductList(genre: "MALE"),
                  ProductList(genre: "FEMALE"),
                ],
              ),
            )
          )
        )
      ],
    );
  }
}
