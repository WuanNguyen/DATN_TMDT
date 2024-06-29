import 'package:doan_tmdt/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int category = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
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
                  height: MediaQuery.of(context).size.height -207,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                  ),
                  // child: ListView.builder(
                  //   itemCount: (item.length/2).ceil(),
                  //   itemBuilder: (context,index){
                  //     if(item.length % 2 !=0 && index == ((item.length /2)-1)){
                  //       return Row(
                  //         children: [
                  //           Product(name: item[index*2].name, price: item[index*2].price)
                  //         ],
                  //       );
                  //     }
                  //     else
                  //     {
                  //       return Row(
                  //         children: [
                  //           Product(name: item[index*2].name, price: item[index*2].price),
                  //           Product(name: item[index*2+1].name, price: item[index*2+1].price),
                  //         ],
                  //       );
                  //     }
                  //   },
                  // ),
                )
                
              ],
            )
          )
          ),
          
        ],
      )
    );
  }
}
