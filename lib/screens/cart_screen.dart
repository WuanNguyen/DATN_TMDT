import 'package:doan_tmdt/model/cart_product.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}


class _CartScreenState extends State<CartScreen> {
  List<CartProductItem> items = List<CartProductItem>.generate(10, (index) => CartProductItem(name: "Product ${index+1}", genre: "Adult", price: index*1000 + 10000));
  List<String> sales = List<String>.generate(11, (index) => "${index*10}%");
  String discountValue = "0%";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
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
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            width: MediaQuery.of(context).size.width/2+166,
            height: MediaQuery.of(context).size.height-350,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context,index){
                return CartProductItem(name: items[index].name, genre: items[index].genre, price: items[index].price);
              },
              )
          ),
          SingleChildScrollView(
            child: Container(
            width: MediaQuery.of(context).size.width,
            height: 155,
            decoration: BoxDecoration(
              color: Color.fromRGBO(207, 207, 207, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(30, 5, 0, 10),
                  child: Column(
                    children: [
                      Row(  //discount
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width-124,
                            child: Text("Discount:",style: TextStyle(fontWeight: FontWeight.bold,fontSize:17),),
                          ),
                          DropdownButton(
                            value: discountValue,
                            onChanged: (String? newValue){
                              setState(() {
                                discountValue = newValue!;
                              });
                            },
                            items: sales.map((String item){
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item));
                            }).toList(), 
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                      Row( //total
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width-124,
                            child: Text("Total:",style: TextStyle(fontWeight: FontWeight.bold,fontSize:17),),
                          ),   
                          Text("20000",style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ],
                  ),
                ),
                Container(//checkout button
                  width: MediaQuery.of(context).size.width-75,
                  height: 40,
                  decoration: BoxDecoration(
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      //todo: checkout
                    }, 
                    child: Text("Checkout")
                  ),
                )
                
              ]
            ),
          ),
          )
         
        ],
      )
    ),
    );
  }
}
