import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

//---------------------Product Size-------------------------
class ProductSize{
  ProductSizeDetail L;
  ProductSizeDetail M;
  ProductSizeDetail S;

  ProductSize({
    required this.L,
    required this.M,
    required this.S,
  });

  factory ProductSize.fromSnapshot(DataSnapshot snapshot){
    return ProductSize(
      L: ProductSizeDetail.fromSnapshot(snapshot.child("L")), 
      M: ProductSizeDetail.fromSnapshot(snapshot.child("M")), 
      S: ProductSizeDetail.fromSnapshot(snapshot.child("S")),
    );
  }
}


//---------------------Product Size Detail-------------------------
class ProductSizeDetail{
  int ID_Product;
  int Stock;
  int ImportPrice;
  int SellPrice;
  int Discount = 0;
  bool Status;

  ProductSizeDetail({
    required this.ID_Product,
    required this.Stock,
    required this.ImportPrice,
    required this.SellPrice,
    required this.Discount,
    required this.Status
  });

  factory ProductSizeDetail.fromSnapshot(DataSnapshot snapshot){
    return ProductSizeDetail(
      ID_Product: int.parse(snapshot.child("ID_Product").value.toString()), 
      Stock: int.parse(snapshot.child("Stock").value.toString()), 
      ImportPrice: int.parse(snapshot.child("ImportPrice").value.toString()), 
      SellPrice: int.parse(snapshot.child("SellPrice").value.toString()), 
      Discount: int.parse(snapshot.child("Discount").value.toString()), 
      Status: snapshot.child("Status").value.toString() == 1 ? true : false,
    );
  }

}


//---------------------Products-------------------------
class Product{
  int ID_Product;
  String Product_Name;
  String Category;
  String Description;
  String Image_Url;
  int ID_Distributor;
  bool Status;
  

  Product({
    required this.ID_Product,
    required this.Product_Name,
    required this.Category,
    required this.Description,
    required this.Image_Url,
    required this.ID_Distributor,
    required this.Status,
  });

  factory Product.fromSnapshot(DataSnapshot snapshot){
    return Product(
      ID_Distributor: int.parse(snapshot.child("ID_Distributor").value.toString()),
      ID_Product: int.parse(snapshot.child("ID_Product").value.toString()),
      Product_Name: snapshot.child("Product_Name").value.toString(),
      Category: snapshot.child("Category").value.toString(),
      Description: snapshot.child("Description").value.toString(),
      Image_Url: snapshot.child("Image_Url").value.toString(),
      Status: int.parse(snapshot.child("Status").value.toString()) == 1 ? true : false,
    );
  }
}


//---------------------Discount-------------------------
class Discount{
  String Description;
  int Price;
  int Required;
  bool Status;

  Discount({
    required this.Description,
    required this.Price,
    required this.Required,
    required this.Status,
  });

  factory Discount.fromSnapshot(DataSnapshot snapshot){
    return Discount(
      Description: snapshot.child("Description").value.toString(), 
      Price: int.parse(snapshot.child("Price").value.toString()),
      Required: int.parse(snapshot.child("Required").value.toString()),
      Status: int.parse(snapshot.child("Status").value.toString()) == 1 ? true : false,
    );
  }

}


//---------------------Distributors-------------------------
class Distributors{
  int ID_Distributor;
  String Distributor_Name;
  String Email;
  String Address;
  String Phone;
  bool Status;

  Distributors({
    required this.ID_Distributor,
    required this.Distributor_Name,
    required this.Email,
    required this.Address,
    required this.Phone,
    required this.Status,
  });

  factory Distributors.fromSnapshot(DataSnapshot snapshot){
    return Distributors(
      ID_Distributor: int.parse(snapshot.child("ID_Distributor").value.toString()),
      Distributor_Name: snapshot.child("Distributor_Name").value.toString(),
      Email: snapshot.child("Email").value.toString(),
      Address: snapshot.child("Address").value.toString(),
      Phone: snapshot.child("Phone").value.toString(),
      Status: int.parse(snapshot.child("Status").value.toString()) == 1 ? true : false,
    );
  }

}


//---------------------Order-------------------------
class Order{
  int ID_Product;
  String ID_ProductSize;
  int Quantity;
  int Discount;
  int Total_Price;
  String Shop_Address;
  String Payment;
  int Order_Status;

  Order({
    required this.ID_Product,
    required this.ID_ProductSize,
    required this.Quantity,
    required this.Discount,
    required this.Total_Price,
    required this.Shop_Address,
    required this.Payment,
    required this.Order_Status,
  });

  factory Order.fromSnapshot(DataSnapshot snapshot){
    return Order(
      ID_Product: int.parse(snapshot.child("ID_Product").value.toString()),
      ID_ProductSize: snapshot.child("ID_ProductSize").value.toString(),
      Quantity: int.parse(snapshot.child("Quantity").value.toString()),
      Discount: int.parse(snapshot.child("Discount").value.toString()),
      Total_Price: int.parse(snapshot.child("Total_Price").value.toString()),
      Shop_Address: snapshot.child("Shop_Address").value.toString(),
      Payment: snapshot.child("payment").value.toString(),
      Order_Status: int.parse(snapshot.child("Order_Status").value.toString()),
    );
  }
}


//---------------------Carts-------------------------
class Cart{
  int ID_Product;
  String ID_ProductSize;
  String ID_User;
  int Quantity;

  Cart({
    required this.ID_Product,
    required this.ID_ProductSize,
    required this.ID_User,
    required this.Quantity,
  });

  factory Cart.fromSnapshot(DataSnapshot snapshot){
    return Cart(
      ID_Product: int.parse(snapshot.child("ID_Product").value.toString()),
      ID_ProductSize: snapshot.child("ID_ProductSize").value.toString(),
      ID_User: snapshot.child("ID_User").value.toString(),
      Quantity: int.parse(snapshot.child("Quantity").value.toString()),
      
    );
  }
}