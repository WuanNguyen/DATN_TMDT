import 'package:firebase_database/firebase_database.dart';

class Product{
  final String img;
  final String name;
  int price;

  Product({
    required this.img,
    required this.name,
    required this.price,
  });

  factory Product.fromSnapShop(DataSnapshot snapshot){
    return Product(
      img: snapshot.child('img').value.toString(),
      name: snapshot.child('name').value.toString(),
      price: int.parse(snapshot.child('price').value.toString())
    );
  }

}

