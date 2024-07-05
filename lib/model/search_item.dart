import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/screens/detail_items/rating.dart';
import 'package:doan_tmdt/screens/detail_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SearchItem extends StatefulWidget {
  SearchItem({super.key,required this.pro});
  Product pro;

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  Query ProductSizes_dbRef = FirebaseDatabase.instance.ref().child('ProductSizes');

  List<ProductSize> sizes = [];



  @override
  void initState(){
    ProductSizes_dbRef.onValue.listen((event) {
        if(this.mounted){
          setState(() {
            sizes = event.snapshot.children.map((snapshot){
              return ProductSize.fromSnapshot(snapshot);
            }).where((element) => element.S.Status == 0 || element.M.Status == 0 || element.L.Status == 0).toList();
          });
        }
      });
  } 
  
  int getPrice(int SellPrice, int Discount){
    return SellPrice - Discount;
  }

  ProductSize empty = ProductSize(
    L: ProductSizeDetail(ID_Product: "", Stock: 0, ImportPrice: 0, SellPrice: 0, Discount: 0, Status: 0), 
    M: ProductSizeDetail(ID_Product: "", Stock: 0, ImportPrice: 0, SellPrice: 0, Discount: 0, Status: 0), 
    S: ProductSizeDetail(ID_Product: "", Stock: 0, ImportPrice: 0, SellPrice: 0, Discount: 0, Status: 0),);
  
  @override
  Widget build(BuildContext context) {
    ProductSize filteredSize =sizes.isNotEmpty ? sizes.firstWhere((element) => element.L.ID_Product == widget.pro.ID_Product) : empty;
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      height: 150,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 255, 255, 255)
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(pro: widget.pro)));
        },
        child: Row(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(30, 0, 20, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1.0),
            ),
            clipBehavior: Clip.antiAlias,
            width: 100,
            height: 100,
            child: Image.network(widget.pro.Image_Url),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.pro.Product_Name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                Text(widget.pro.Category,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                Text("${getPrice(filteredSize.S.SellPrice, filteredSize.S.Discount)} - ${getPrice(filteredSize.L.SellPrice, filteredSize.L.Discount)} VND",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.star_rounded,color: Colors.yellow,),
                    Text("2.5",),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(pro: widget.pro)));
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
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
              ],
            ),
          )
        ],
      ),
      )
    );
  }
}