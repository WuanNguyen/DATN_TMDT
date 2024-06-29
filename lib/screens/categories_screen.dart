import 'package:doan_tmdt/model/product.dart';
import 'package:doan_tmdt/model/product_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
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

  int category = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
        ) ,
      ),
      child: Container(
      margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5)),
          Row(
            children: [
              OutlinedButton(
                onPressed: (){
                  setState(() {
                    category = 0;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(category==0?Color.fromRGBO(197, 230, 214, 1):null),
                  side: WidgetStatePropertyAll(BorderSide(width: category==0?2.0:0.5))
                ),
                child: Text("Adult")
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
              OutlinedButton(
                onPressed: (){
                  setState(() {
                    category = 1;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(category==1?Color.fromRGBO(197, 230, 214, 1):null),
                  side: WidgetStatePropertyAll(BorderSide(width: category==1?2.0:0.5))
                ),
                child: Text("Child")
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height -250,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/2 - 195, 0, 0, 0),
            decoration: BoxDecoration(
            ),
            child: ListView.builder(
              itemCount: (pro.length/2).ceil(),
              itemBuilder: (context,index){
                if(pro.length % 2 !=0 && index == ((pro.length/2).ceil()-1)){
                  return Row(
                    children: [
                      ProductItem(pro: pro[index*2])
                    ],
                  );
                }
                else
                {
                  return Row(
                    children: [
                      ProductItem(pro: pro[index*2]),
                      ProductItem(pro: pro[index*2+1])
                    ],
                  );
                }
              },
            ),
          )
          
        ],
      )
    )
    ),
    );
  }
}
