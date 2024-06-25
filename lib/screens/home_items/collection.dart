import 'package:flutter/material.dart';

class Collection extends StatefulWidget {
  Collection({super.key,required this.name});
  String name; //Collection name
  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  //image
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width - 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    clipBehavior: Clip.antiAlias,// cho image fit voi container
                    child: Image.network("https://ninjersey.com/cdn/shop/files/ESPORT-JERSEY-DESIGN-FIRE_1400x.jpg?v=1635508121",fit:BoxFit.cover),
                  ),

                  //Title text
                  Container(
                    decoration:const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    height: 200,
                    width: MediaQuery.of(context).size.width - 42,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(widget.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 0.5),),
                        Container(height: 10,)
                      ],
                    ),
                  )
                ]   
              )
            ],
          )
        ],
      ),
    );
  }
}