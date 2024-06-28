import 'package:doan_tmdt/model/product.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  ProductList({super.key, required this.genre});
  String genre;
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(widget.genre,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
          Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Product(name: "Blue", price: 100000),
                Product(name: "Blue", price: 100000),
                Product(name: "Blue", price: 100000),
              ],
            ),
          )
        ],
      ),
    );
  }
}