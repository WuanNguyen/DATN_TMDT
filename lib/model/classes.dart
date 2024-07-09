import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// User ------------------------------------------------------

class Users {
  String ID_User;
  String Address;
  String Image_Url;
  String Username;
  String Phone;
  int Status;
  Users({
    required this.ID_User,
    required this.Address,
    required this.Image_Url,
    required this.Username,
    required this.Phone,
    required this.Status,
  });
  factory Users.fromSnapshot(DataSnapshot snapshot) {
    return Users(
      ID_User: snapshot.child("ID_User").value.toString(),
      Address: snapshot.child("Address").value.toString(),
      Image_Url: snapshot.child("Image_Url").value.toString(),
      Username: snapshot.child("Username").value.toString(),
      Phone: snapshot.child("Phone").value.toString(),
      Status: int.parse(snapshot.child("Status").value.toString()),
    );
  }
}

//---------------------Product Size-------------------------
class ProductSize {
  ProductSizeDetail L;
  ProductSizeDetail M;
  ProductSizeDetail S;

  ProductSize({
    required this.L,
    required this.M,
    required this.S,
  });

  factory ProductSize.fromSnapshot(DataSnapshot snapshot) {
    return ProductSize(
      L: ProductSizeDetail.fromSnapshot(snapshot.child("L")),
      M: ProductSizeDetail.fromSnapshot(snapshot.child("M")),
      S: ProductSizeDetail.fromSnapshot(snapshot.child("S")),
    );
  }
}

//---------------------Product Size Detail-------------------------
class ProductSizeDetail {
  String ID_Product;
  int Stock;
  int ImportPrice;
  int SellPrice;
  int Discount = 0;
  int Status;

  ProductSizeDetail(
      {required this.ID_Product,
      required this.Stock,
      required this.ImportPrice,
      required this.SellPrice,
      required this.Discount,
      required this.Status});

  factory ProductSizeDetail.fromSnapshot(DataSnapshot snapshot) {
    return ProductSizeDetail(
        ID_Product: snapshot.child("ID_Product").value.toString(),
        Stock: int.parse(snapshot.child("Stock").value.toString()),
        ImportPrice: int.parse(snapshot.child("ImportPrice").value.toString()),
        SellPrice: int.parse(snapshot.child("SellPrice").value.toString()),
        Discount: int.parse(snapshot.child("Discount").value.toString()),
        Status: int.parse(snapshot.child("Status").value.toString()));
  }
}

//---------------------Products-------------------------
class Product {
  //int ID_Product;
  String ID_Product;
  String Product_Name;
  String Category;
  String Description;
  String Image_Url;
  String ID_Distributor;
  int Status;

  Product({
    required this.ID_Product,
    required this.Product_Name,
    required this.Category,
    required this.Description,
    required this.Image_Url,
    required this.ID_Distributor,
    required this.Status,
  });

  factory Product.fromSnapshot(DataSnapshot snapshot) {
    return Product(
        ID_Distributor: snapshot.child("ID_Distributor").value.toString(),
        ID_Product: snapshot.child("ID_Product").value.toString(),
        Product_Name: snapshot.child("Product_Name").value.toString(),
        Category: snapshot.child("Category").value.toString(),
        Description: snapshot.child("Description").value.toString(),
        Image_Url: snapshot.child("Image_Url").value.toString(),
        Status: int.parse(snapshot.child("Status").value.toString()));
  }
}

//---------------------Discount------------------------- đã fix
class Discount {
  String Description;
  String id;
  //int id;
  int Uses;
  int Price;
  int Required;
  int Status;

  Discount({
    required this.Description,
    required this.id,
    required this.Uses,
    required this.Price,
    required this.Required,
    required this.Status,
  });

  factory Discount.fromSnapshot(DataSnapshot snapshot) {
    return Discount(
      Description: snapshot.child("Description").value.toString(),
      id: snapshot.child('ID_Discount').value.toString(),
      //id: int.parse(snapshot.child("ID_Discount").value.toString()),
      Uses: int.parse(snapshot.child("Uses").value.toString()),
      Price: int.parse(snapshot.child("Price").value.toString()),
      Required: int.parse(snapshot.child("Required").value.toString()),
      Status: int.parse(snapshot.child("Status").value.toString()),
    );
  }
}

//---------------------Distributors------------------------- đã fix
class Distributors {
  //int ID_Distributor;
  String ID_Distributor;
  String Distributor_Name;
  String Email;
  String Address;
  String Phone;
  int Status;

  Distributors({
    required this.ID_Distributor,
    required this.Distributor_Name,
    required this.Email,
    required this.Address,
    required this.Phone,
    required this.Status,
  });

  factory Distributors.fromSnapshot(DataSnapshot snapshot) {
    return Distributors(
        ID_Distributor: snapshot.child("ID_Distributor").value.toString(),
        Distributor_Name: snapshot.child("Distributor_Name").value.toString(),
        Email: snapshot.child("Email").value.toString(),
        Address: snapshot.child("Address").value.toString(),
        Phone: snapshot.child("Phone").value.toString(),
        Status: int.parse(snapshot.child("Status").value.toString()));
  }
}

//---------------------Order-------------------------
class Order {
  String nameuser;
  String addressuser;
  String phoneuser;
  String ID_Order;
  String ID_User;
  int Discount;
  int Total_Price;
  String Order_Date;
  String Payment;
  String Order_Status;

  ///

  Order({
    required this.nameuser,
    required this.addressuser,
    required this.phoneuser,
    required this.ID_Order,
    //required this.ID_Product,
    required this.ID_User,
    //required this.ID_ProductSize,
    // required this.Quantity,
    required this.Discount,
    required this.Total_Price,
    required this.Order_Date,
    //required this.Shop_Address,
    required this.Payment,
    required this.Order_Status,
  });

  factory Order.fromSnapshot(DataSnapshot snapshot) {
    return Order(
      nameuser: snapshot.child("NameUser").value.toString(),
      addressuser: snapshot.child("AddressUser").value.toString(),
      phoneuser: snapshot.child("PhoneUser").value.toString(),
      ID_Order: snapshot.child("ID_Order").value.toString(),
      //ID_Product: int.parse(snapshot.child("ID_Product").value.toString()),
      ID_User: snapshot.child("ID_User").value.toString(),
      //ID_ProductSize: snapshot.child("ID_ProductSize").value.toString(),
      //Quantity: int.parse(snapshot.child("Quantity").value.toString()),
      Discount: int.parse(snapshot.child("Discount").value.toString()),
      Total_Price: int.parse(snapshot.child("Total_Price").value.toString()),
      Order_Date: snapshot.child("Order_Date").value.toString(),
      //Shop_Address: snapshot.child("Shop_Address").value.toString(),
      Payment: snapshot.child("Payment").value.toString(),
      Order_Status: snapshot.child("Order_Status").value.toString(),
    );
  }
}

// class OrderDetail---------------------------------------
class OrderDetail {
  final String idProduct;
  final String idProductSize;
  final int price;
  final int quantity;

  OrderDetail({
    required this.idProduct,
    required this.idProductSize,
    required this.price,
    required this.quantity,
  });

  factory OrderDetail.fromSnapshot(DataSnapshot snapshot) {
    return OrderDetail(
      idProduct: snapshot.child("ID_Product").value.toString(),
      idProductSize: snapshot.child("ID_ProductSize").value.toString(),
      price: int.parse(snapshot.child("Price").value.toString()),
      quantity: int.parse(snapshot.child("Quantity").value.toString()),
    );
  }
}

//---------------------Carts-------------------------
class Cart {
  String ID_User;
  List<CartDetail> Detail;

  Cart({
    required this.ID_User,
    required this.Detail,
  });

  factory Cart.fromSnapshot(DataSnapshot snapshot) {
    String idUser = snapshot.key ?? '';
    List<CartDetail> tempDetails = [];

    for (var child in snapshot.children) {
      if (child.value != null) {
        tempDetails.add(CartDetail.fromSnapshot(child));
      }
    }
    return Cart(
      ID_User: idUser,
      Detail: tempDetails,
    );
  }
}

//-----------------------------------------------------------------------------------đã fix
//---------------------Cart Detail-------------------------
class CartDetail {
  String ID_Cart;
  String ID_Product;
  String ID_ProductSize;
  int Stt;
  int Quantity;

  CartDetail({
    required this.ID_Cart,
    required this.ID_Product,
    required this.ID_ProductSize,
    required this.Stt,
    required this.Quantity,
  });

  factory CartDetail.fromSnapshot(DataSnapshot snapshot) {
    return CartDetail(
      ID_Cart: snapshot.child("ID_Cart").value.toString(),
      ID_Product: snapshot.child("ID_Product").value.toString(),
      ID_ProductSize: snapshot.child("ID_ProductSize").value.toString(),
      Stt: int.parse(snapshot.child("Stt").value.toString()),
      Quantity: int.parse(snapshot.child("Quantity").value.toString()),
    );
  }
}

class Dis {
  String ID_Distributor;
  String Distributor_Name;
  String Email;
  String Address;
  String Phone;
  int Status;

  Dis({
    required this.ID_Distributor,
    required this.Distributor_Name,
    required this.Email,
    required this.Address,
    required this.Phone,
    required this.Status,
  });

  factory Dis.fromSnapshot(DataSnapshot snapshot) {
    return Dis(
        ID_Distributor: snapshot.child("ID_Distributor").value.toString(),
        Distributor_Name: snapshot.child("Distributor_Name").value.toString(),
        Email: snapshot.child("Email").value.toString(),
        Address: snapshot.child("Address").value.toString(),
        Phone: snapshot.child("Phone").value.toString(),
        Status: int.parse(snapshot.child("Status").value.toString()));
  }
}

//-----------------------------------------------------------
class Favorite {
  String ID_Product;
  int Status;
  Favorite({required this.ID_Product, required this.Status});
  factory Favorite.fromSnapshot(DataSnapshot snapshot) {
    return Favorite(
      ID_Product: snapshot.child("ID_Product").value.toString(),
      Status: int.parse(snapshot.child("Status").value.toString()),
    );
  }
}

//---------------------Review-------------------------
class Review {
  String ID_Product;
  String ID_Review;
  String ID_User;
  String Username;
  int Rating;
  String Comment;
  String Review_Date;
  int Status;

  Review({
    required this.ID_Product,
    required this.ID_Review,
    required this.ID_User,
    required this.Username,
    required this.Rating,
    required this.Comment,
    required this.Review_Date,
    required this.Status,
  });

  factory Review.fromSnapshot(DataSnapshot snapshot) {
    return Review(
      ID_Product: snapshot.child("ID_Product").value.toString(),
      ID_Review: snapshot.child("ID_Review").value.toString(),
      ID_User: snapshot.child("ID_User").value.toString(),
      Username: snapshot.child("Username").value.toString(),
      Rating: int.parse(snapshot.child("Rating").value.toString()),
      Comment: snapshot.child("Comment").value.toString(),
      Review_Date: snapshot.child("Review_Date").value.toString(),
      Status: int.parse(snapshot.child("Status").value.toString()),
    );
  }
}
