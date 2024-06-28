import 'package:flutter/material.dart';

class CartProduct extends StatefulWidget {
  CartProduct({super.key,required this.name, required this.genre, required this.price});
  String name;
  String genre;
  int price;

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
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
            child: Image.network("https://paper.vn/wp-content/uploads/2023/11/placeholder-4.png",fit: BoxFit.cover,),
          ),
          Container(
            width: MediaQuery.of(context).size.width/2 -89,
            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize:17),),
                Text(widget.genre,style:TextStyle(fontSize:13)),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5)),
                Text("${widget.price} VND",style: TextStyle(fontSize:13,fontWeight:FontWeight.bold),)
              ],
            ),
          ),
          Column(
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
                            quantity+=1;
                          });
                        }, 
                        icon: Icon(Icons.add,color: Colors.white,size:20))
                    ),
                    Container(//text
                      width: 20,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text("$quantity",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
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
                            if(quantity>0)
                            quantity-=1;
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
    );
  }
}