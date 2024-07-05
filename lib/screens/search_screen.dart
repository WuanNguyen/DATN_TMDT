import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/model/search_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Query Products_dbRef = FirebaseDatabase.instance.ref().child('Products');

  List<Product> pro = [];
  List<Product> filteredPro = [];
  List<Product> searchPro = [];

  String searchValue = "";

  @override
  void initState() {
    Products_dbRef.onValue.listen((event) {
      if(this.mounted){
        setState(() {
          pro = event.snapshot.children.map((snapshot){
            return Product.fromSnapshot(snapshot);
          }).where((element) => element.Status == 0).toList();
          filtProduct();
          searchPro = pro;
        });
      }
    });
  }

  int category = 0;
  void filtProduct(){
    if(category == 0) filteredPro = pro;
    if(category == 1) filteredPro = pro.where((element) => element.Category == "Adult").toList();
    if(category == 2) filteredPro = pro.where((element) => element.Category == "Child").toList();
  }

  @override
  Widget build(BuildContext context) {
    filtProduct();
    searchPro = filteredPro.where((element) => element.Product_Name.toString().contains(searchValue),).toList();
    return Scaffold(
      appBar: AppBar(
          scrolledUnderElevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Color.fromRGBO(201, 241, 248, 1),
          title: TextField(
            //controller: searchController,
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: (value){
              setState(() {
                searchValue = value;
              });
              },
          )
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
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
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromRGBO(201, 241, 248, 1)
              ),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                  OutlinedButton(
                    onPressed: (){
                      setState(() {
                        category = 0;
                        filtProduct();
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(category==0?Color.fromRGBO(197, 230, 214, 1):Color.fromRGBO(197, 230, 214, 0)),
                      side: WidgetStatePropertyAll(BorderSide(width: category==0?2.0:0.5))
                    ),
                    child: Text("All")
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                  OutlinedButton(
                    onPressed: (){
                      setState(() {
                        category = 1;
                        filtProduct();
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(category==1?Color.fromRGBO(197, 230, 214, 1):null),
                      side: WidgetStatePropertyAll(BorderSide(width: category==1?2.0:0.5))
                    ),
                    child: Text("Adult")
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                  OutlinedButton(
                    onPressed: (){
                      setState(() {
                        category = 2;
                        filtProduct();
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(category==2?Color.fromRGBO(197, 230, 214, 1):null),
                      side: WidgetStatePropertyAll(BorderSide(width: category==2?2.0:0.5))
                    ),
                    child: Text("Child")
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: 722,
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: searchPro.length,
                  itemBuilder: (context,index){
                    return SearchItem(pro: searchPro[index]);
                  }
                ),
              ),
            )
          ],
        ),
          ),
        )
    );
  }
}