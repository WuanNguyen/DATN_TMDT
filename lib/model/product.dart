import 'package:doan_tmdt/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class Product extends StatefulWidget {
  Product({super.key,required this.name,required this.price});
  String name;
  int price;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> new DetailScreen(name: widget.name,price: widget.price,)));
      }, //qua trang san pham
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
        width: 167,
        height: 268,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.all(11)),
            Container(
              clipBehavior: Clip.antiAlias,// cho hinh anh vao trong container
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color:const Color.fromARGB(255, 57, 46, 46),width: 2.0),
                color:Colors.white
                ),
              child: Image.network("https://i.pinimg.com/736x/e9/3c/2a/e93c2ac0194c53610dfeea86edd1e702.jpg",fit:BoxFit.cover)//image (fit: BoxFit.cover)
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),


            //name
            Text(widget.name,style:const  TextStyle(color: Color.fromARGB(255, 48, 50, 52),fontWeight: FontWeight.bold),),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
            
            //price
            Text("${widget.price} VNĐ",style:TextStyle(fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 0)),

            //button
            GestureDetector(
              onTap: (){
                print("Added to cart");
              },//todo: thêm vào giỏ hàng
              child: Container(
                width: 126,
                height: 46,
                decoration: BoxDecoration(
                  color:const Color.fromARGB(255, 215, 215, 215),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      blurRadius: 2,
                      offset: Offset(0, 1)
                    )
                  ]
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_shopping_cart_rounded),
                    Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                    Text("Add to cart",style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}