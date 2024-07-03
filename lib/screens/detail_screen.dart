import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/screens/detail_items/rating.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({super.key,required this.pro});
  Product pro;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Query ProductSizes_dbRef = FirebaseDatabase.instance.ref().child('ProductSizes');
  List<ProductSize> sizes = [];

  ProductSize size = ProductSize(S: ProductSizeDetail(ID_Product: 0, Stock: 0, ImportPrice: 0, SellPrice: 0,Discount: 0, Status: false),M:ProductSizeDetail(ID_Product: 0, Stock: 0, ImportPrice: 0, SellPrice: 0,Discount: 0, Status: false),L:ProductSizeDetail(ID_Product: 0, Stock: 0, ImportPrice: 0, SellPrice: 0,Discount: 0, Status: false));
  int price = 0;
  int discount = 0;
  int sizeBtn = 0; // 0 => size S, 1 => size M, 2 => size L

  @override
    void initState(){
      ProductSizes_dbRef.onValue.listen((event) {
        if(this.mounted){
          setState(() {
            sizes = event.snapshot.children.map((snapshot){
              return ProductSize.fromSnapshot(snapshot);
            }).toList();
            size = sizes.firstWhere((element) =>element.L.ID_Product == widget.pro.ID_Product);
            price = size.S.SellPrice;
            discount = size.S.Discount;
          });
        }
      });
    }


  void SizeFilter(){
    if(sizeBtn == 0){// size S
      price = size.S.SellPrice;
      discount = size.S.Discount;
    }
    if(sizeBtn == 1){// size M
      price = size.M.SellPrice;
      discount = size.M.Discount;
    }
    if(sizeBtn == 2){// size L
      price = size.L.SellPrice;
      discount = size.L.Discount;
    }
  }
  void CheckSize(){
    if(size.S.Stock == 0 || size.S.Status == 1) sizeBtn == 1;
    if(size.M.Stock == 0 || size.M.Status == 1) sizeBtn == 2;
    if(size.L.Stock == 0 || size.L.Status == 1) sizeBtn == 3;
  }
  bool OutOfStock(){
    if(size.S.Stock != 0)
      if(size.M.Stock !=0)
        if(size.L.Stock != 0)
          return false;
    return true;
  }


  @override
  Widget build(BuildContext context) {
    if(size.S.Stock == 0 || size.S.Status == 1) sizeBtn == 1;
    if(size.M.Stock == 0 || size.M.Status == 1) sizeBtn == 2;
    if(size.L.Stock == 0 || size.L.Status == 1) sizeBtn == 3;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor:const Color.fromRGBO(201, 241, 248, 1),
        leading: Container(
          decoration: BoxDecoration(
            //color:Color.fromRGBO(63, 55, 86, 0.32),
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child:Icon(Icons.arrow_back_ios_new,color:Colors.black)
          ),
        )
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
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
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(// hinh anh
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              width: MediaQuery.of(context).size.height / 3,
              height: MediaQuery.of(context).size.height / 3,
              child: Image.network(widget.pro.Image_Url,fit:BoxFit.cover)//image (fit: BoxFit.cover)
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 3) - 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
                color:Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row( 
                      children: [
                        Container( //ten, gia tien va danh gia
                          width: MediaQuery.of(context).size.width - 197,
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.pro.Product_Name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              Text(OutOfStock()? "Out of Stock" : "${price} VND", style: TextStyle(decoration: discount> 0? TextDecoration.lineThrough: TextDecoration.none),),
                              if(discount >0) Text("${price - discount} VND",style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromRGBO(232, 174, 17, 1)),),
                              Rating(rate:3.5)
                              
                              //todo: rating
                            ],
                          ),
                        ),
                        if((size.S.Stock != 0 || size.M.Stock != 0 || size.L.Stock != 0) || (size.S.Status == 1 && size.M.Status == 1 && size.L.Status == 1))
                        GestureDetector( //button
                          onTap: (){
                            print("Added to cart");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            padding: EdgeInsets.fromLTRB(10, 12, 20, 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              color: Color.fromRGBO(239, 237, 237, 1)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.add_shopping_cart_rounded),
                                Text("Add to cart")
                              ],
                            )
                          ),
                        )
                      ],
                    ),
                    Column( // size
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if((size.S.Stock != 0 || size.M.Stock != 0 || size.L.Stock != 0) || (size.S.Status == 1 && size.M.Status == 1 && size.L.Status == 1))
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text("Size",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                          ),
                        
                        Row(// size button
                          children: [
                            if(size.S.Status == 0 || size.S.Stock != 0)
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  sizeBtn = 0;
                                  SizeFilter();
                                });
                              }, 
                              style: ButtonStyle(
                                side: WidgetStatePropertyAll(
                                  BorderSide(width: sizeBtn==0?2.0:0.5)
                                  ),
                              ),
                              child: Text("S",style:TextStyle(color: Colors.black))
                              ),
                            ),
                            
                            //Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),),

                            if(size.M.Status == 0 || size.M.Stock !=0)
                            OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  sizeBtn = 1;
                                  SizeFilter();
                                });
                              }, 
                              style: ButtonStyle(
                                side: WidgetStatePropertyAll(
                                  BorderSide(width: sizeBtn==1?2.0:0.5)
                                  ),
                              ),
                              child: Text("M",style:TextStyle(color: Colors.black))
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),),

                            if(size.L.Status == 0 || size.L.Stock !=0 )
                            OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  sizeBtn = 2;
                                  SizeFilter();
                                });
                              }, 
                              style: ButtonStyle(
                                side: WidgetStatePropertyAll(
                                  BorderSide(width: sizeBtn==2?2.0:0.5)
                                  ),
                              ),
                              child: Text("L",style:TextStyle(color: Colors.black))
                            ),
                          ],
                        )
                      ],
                    ),
                    SingleChildScrollView(//phan mo ta
                      physics: NeverScrollableScrollPhysics(),
                      child: Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 7, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Description",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                          Text(widget.pro.Description),
                          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10))
                        ],
                      ),
                    )
                  )
                ],
              ),
              )
            )
          ],
        ),
      ),
      )
    );
  }
}