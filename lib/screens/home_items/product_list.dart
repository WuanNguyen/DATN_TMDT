import 'package:doan_tmdt/model/product.dart';
import 'package:doan_tmdt/model/classes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductList extends StatefulWidget {
  ProductList({super.key, required this.CategoryName,required this.Category});
  String CategoryName;
  String Category;
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Query Products_dbRef = FirebaseDatabase.instance.ref().child('Products');
  List<Product> pro = [];
  @override
  void initState() {
    Products_dbRef.onValue.listen((event) {
      if (this.mounted) {
        setState(() {
          pro = event.snapshot.children
              .map((snapshot) => Product.fromSnapshot(snapshot))
              .where((element) => element.Status == 0 && element.Category == widget.Category)
              .toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.CategoryName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
          Container(
            height: 310,
            width: 393,
            child: pro.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pro.length,
                    itemBuilder: (context, index) {
                      return ProductItem(pro: pro[index]);
                    })
                : Center(child: Text('No products found')),
          )
        ],
      ),
    );
  }
}
