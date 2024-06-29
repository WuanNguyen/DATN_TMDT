import 'package:doan_tmdt/model/product.dart';
import 'package:doan_tmdt/model/product_class.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class ProductList extends StatefulWidget {
  ProductList({super.key, required this.genre});
  String genre;
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Query _dbRef = FirebaseDatabase.instance.ref().child('Products');
  List<Product> pro = [];

  @override
  void initState(){
    _dbRef.onValue.listen((event) {
      if(this.mounted){
        setState(() {
          pro = event.snapshot.children.map((snapshot){
            return Product.fromSnapShop(snapshot);
          }).toList();
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
          Text(widget.genre,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
          Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
          Container(//todo: sua width
              height: 310,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection:  Axis.horizontal,
                itemCount: pro.length,
                itemBuilder: (context,index){
                  print(MediaQuery.of(context).size.width);
                  return ProductItem(pro: pro[index*2]);
                }
              )
            )
          
        ],
      ),
    );
  }
}