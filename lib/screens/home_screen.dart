import 'package:doan_tmdt/model/product.dart';
import 'package:doan_tmdt/screens/home_items/collection.dart';
import 'package:doan_tmdt/screens/home_items/product_list.dart';
import 'package:doan_tmdt/screens/search_screen.dart';
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
    return SingleChildScrollView(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 1000,
          decoration: BoxDecoration(
            color: Color.fromRGBO(201, 241, 248, 1),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    16, 8, 16, 8), // Điều chỉnh khoảng cách viền
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(25), // Điều chỉnh độ cong của viền
                  border: Border.all(
                    color: Colors.grey
                        .withOpacity(0.5), // Màu sắc và độ mờ của viền
                    width: 1.5, // Độ dày của viền
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      SizedBox(
                          width: 10), // Khoảng cách giữa biểu tượng và văn bản
                      Icon(Icons.search, color: Colors.grey.withOpacity(0.5)),
                      SizedBox(
                          width: 10), // Khoảng cách giữa biểu tượng và văn bản
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none, // Xóa viền của TextField
                            hintText: "Search...",
                          ),
                          enabled:
                              false, // Không cho phép chỉnh sửa trực tiếp trong TextField
                        ),
                      ),
                    ],
                  ),
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
                      height: MediaQuery.of(context).size.height - 186,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Collection(name: "ELEMENT COLLECTION"),
                            ProductList(genre: "MALE"),
                            ProductList(genre: "FEMALE"),
                          ],
                        ),
                      )))
            ],
          )),
    );
  }
}
