import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/screens/detail_items/rating.dart';
import 'package:doan_tmdt/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductItem extends StatefulWidget {
  ProductItem({super.key,required this.pro});
  Product pro;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  Query ProductSizes_dbRef = FirebaseDatabase.instance.ref().child('ProductSizes');
  List<ProductSize> sizes = [];
  ProductSize size = ProductSize(S: ProductSizeDetail(ID_Product: 0, Stock: 0, ImportPrice: 0, SellPrice: 0,Discount: 0, Status: false),M:ProductSizeDetail(ID_Product: 0, Stock: 0, ImportPrice: 0, SellPrice: 0,Discount: 0, Status: false),L:ProductSizeDetail(ID_Product: 0, Stock: 0, ImportPrice: 0, SellPrice: 0,Discount: 0, Status: false));

  @override
    void initState(){
      ProductSizes_dbRef.onValue.listen((event) {
        if(this.mounted){
          setState(() {
            sizes = event.snapshot.children.map((snapshot){
              return ProductSize.fromSnapshot(snapshot);
            }).toList();
            size = sizes.firstWhere((element) =>
              element.L.ID_Product == widget.pro.ID_Product ||  
              element.M.ID_Product == widget.pro.ID_Product || 
              element.S.ID_Product == widget.pro.ID_Product
            );
          });
        }
      });
    }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> new DetailScreen(pro: widget.pro,)));
      }, //qua trang san pham
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
        width: 167,
        height: 300,
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
              child: Image.network(widget.pro.Image_Url,fit:BoxFit.cover)//image (fit: BoxFit.cover)
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),


            //name
            Text(widget.pro.Product_Name,style:const  TextStyle(color: Color.fromARGB(255, 48, 50, 52),fontWeight: FontWeight.bold),),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
            
            //price
            Text("${size.S.SellPrice - size.S.Discount} - ${size.L.SellPrice - size.L.Discount} VND",style:TextStyle(fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 0)),

            Container(margin: EdgeInsets.fromLTRB(20, 0, 0, 0),child: Rating(rate: 3.5),),

            //button
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> new DetailScreen(pro: widget.pro,)));
              },
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
                    //todo: rating
                    Text("View",style: TextStyle(fontWeight: FontWeight.bold),)
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