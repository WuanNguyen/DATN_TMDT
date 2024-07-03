import 'dart:developer';

import 'package:doan_tmdt/model/cart_product.dart';
import 'package:doan_tmdt/model/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}


class _CartScreenState extends State<CartScreen> {
    Query Discount_dbRef = FirebaseDatabase.instance.ref().child('Discounts');
    Query Cart_dbRef = FirebaseDatabase.instance.ref().child('Carts');
    Query Products_dbRef = FirebaseDatabase.instance.ref().child('Products');
    Query ProductSizes_dbRef = FirebaseDatabase.instance.ref().child('ProductSizes');

    String getUserUID(){
      User? user = FirebaseAuth.instance.currentUser;
      if(user != null)
        return user.uid.toString();
      return "";
    }

    int getPrice(int SellPrice,int DiscountPrice){
      return SellPrice-DiscountPrice;
    }
    int getTotalPrice(List<Cart> c,List<ProductSize> ps){
      int total = 0;
      c.forEach((c){
        ps.forEach((ps){
          if(c.ID_Product == ps.S.ID_Product){
            total += int.parse(c.Quantity.toString()) * (c.ID_ProductSize == "S" ? getPrice(ps.S.SellPrice, ps.S.Discount) : c.ID_ProductSize == "M" ? getPrice(ps.M.SellPrice, ps.M.Discount) : getPrice(ps.L.SellPrice, ps.L.Discount));
          }
        });
      });
      return total;
    }

    int TotalPrice = 0;

    List<Discount> discounts = [];
    List<Discount> validDiscounts = [];
    List<Cart> cart = [];
    List<Product> pro = [];
    List<Product> filteredPro = [];
    List<ProductSize> sizes = [];
    List<ProductSize> filtedredSizes = [];

    int? discountValue = 0;
  
   @override
    void initState(){
      Discount_dbRef.onValue.listen((event) {
        if(this.mounted){
          setState(() {
            discounts = event.snapshot.children.map((snapshot){
              return Discount.fromSnapshot(snapshot);
            }).where((element) => element.Status == false).toList();
            validDiscounts = discounts;
            if (validDiscounts.isNotEmpty) {
              discountValue = int.parse(validDiscounts[0].Price.toString());
            }
          });
        }
      });
      Cart_dbRef.onValue.listen((event) {
        if(this.mounted){
          setState(() {
            cart = event.snapshot.children.map((snapshot){
              return Cart.fromSnapshot(snapshot);
            }).where((element) => element.ID_User.contains(getUserUID())).toList();
          });
        }
      });
      Products_dbRef.onValue.listen((event) {
        if(this.mounted){
          setState(() {
            pro = event.snapshot.children.map((snapshot){
              return Product.fromSnapshot(snapshot);
            }).toList();
          });
        }
      });
      ProductSizes_dbRef.onValue.listen((event) {
        if(this.mounted){
          setState(() {
            sizes = event.snapshot.children.map((snapshot){
              return ProductSize.fromSnapshot(snapshot);
            }).where((element) => element.L.Status == false || element.M.Status == false || element.S.Status == false).toList();
          });
        }
      });
    }

    
  
  @override
  Widget build(BuildContext context) {
    cart.forEach((c){
        pro.forEach((p){
          if(int.parse(p.ID_Product.toString()) == int.parse(c.ID_Product.toString())){
            filteredPro.add(p);
          }
        });
      });
      filteredPro.forEach((product){
        sizes.forEach((size){
          if(size.L.ID_Product == product.ID_Product)
            filtedredSizes.add(size);
        });
      });
      TotalPrice = getTotalPrice(cart, sizes);
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
            child: ListView.builder( //Cart Item
              itemCount: cart.length,
              itemBuilder: (context,index){
                return Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: MediaQuery.of(context).size.width /2+153,
                  height: 130,
                  decoration: BoxDecoration(
                    color:Colors.white,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(//hinh anh
                        margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        width: 100,
                        height: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2.0
                          )
                        ),
                        child: Image.network(filteredPro[index].Image_Url,fit: BoxFit.cover,),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2+ 25,
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(filteredPro[index].Product_Name.toString() +" - " + cart[index].ID_ProductSize,style: TextStyle(fontWeight: FontWeight.bold,fontSize:17),),
                            Text(filteredPro[index].Category,style:TextStyle(fontSize:13)),
                            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5)),
                            Text(cart[index].ID_ProductSize == "S" ? getPrice(filtedredSizes[index].S.SellPrice, filtedredSizes[index].S.Discount).toString() 
                              : cart[index].ID_ProductSize == "M" ? getPrice(filtedredSizes[index].M.SellPrice, filtedredSizes[index].M.Discount).toString()
                               : getPrice(filtedredSizes[index].L.SellPrice, filtedredSizes[index].L.Discount).toString(),
                            style: TextStyle(fontSize:13,fontWeight:FontWeight.bold),),
                            Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(//quantity adjust
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Row(
                              children: [
                                Container(//add quantity
                                  margin: EdgeInsets.fromLTRB(0, 0, 0,0),
                                  width: 36,
                                  height: 36,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        //todo: upload quantity len db
                                        cart[index].Quantity+=1;
                                        TotalPrice = getTotalPrice(cart, sizes);
                                      });
                                    }, 
                                    icon: Icon(Icons.add,color: Colors.white,size:20))
                                ),
                                Container(//text
                                  width: 20,
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text(cart[index].Quantity.toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                ),
                                Container(//remove quantity
                                  width: 36,
                                  height: 36,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        //todo: upload quantity len db
                                        if(cart[index].Quantity>0)
                                        cart[index].Quantity-=1;
                                        TotalPrice = getTotalPrice(cart, sizes);
                                      });
                                    }, 
                                    icon: Icon(Icons.remove,color: Colors.white,size:20))
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                          ],
                          
                        ),
                      ),
                      
                    ],
                  ),
                );
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
                          DropdownButton<String>(
                            value: discountValue.toString(),
                            onChanged: (String? newValue){
                              setState((){
                                discountValue = int.parse(newValue.toString());
                              });
                            },
                            items: validDiscounts.map((Discount validDiscounts){
                              return DropdownMenuItem<String>(
                                value: validDiscounts.Price.toString(),
                                child: Text(validDiscounts.Price.toString()));
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
                          Text("${TotalPrice - int.parse(discountValue.toString())}",style: TextStyle(fontWeight: FontWeight.bold),)
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
