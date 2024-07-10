import 'package:doan_tmdt/model/cart_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:doan_tmdt/model/cart_product.dart';
import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/model/product.dart';
import 'package:doan_tmdt/screens/detail_screen.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Query discountDbRef = FirebaseDatabase.instance.ref().child('Discounts');
  Query cartDbRef = FirebaseDatabase.instance.ref().child('Carts');
  Query productsDbRef = FirebaseDatabase.instance.ref().child('Products');
  Query productSizesDbRef =
      FirebaseDatabase.instance.ref().child('ProductSizes');
  late final Query userCartDbRef;

  String getUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) return user.uid.toString();
    return "";
  }

  int getPrice(int sellPrice, int discountPrice) {
    return sellPrice - discountPrice;
  }

  int getTotalPrice(List<CartDetail> c, List<ProductSize> s) {
    int price = 0;

    for (var item in c) {
      for (var size in s) {
        if (item.ID_Product == size.S.ID_Product) {
          if (item.ID_ProductSize.toLowerCase() == "l") {
            price +=
                getPrice(size.L.SellPrice, size.L.Discount) * item.Quantity;
          } else if (item.ID_ProductSize.toLowerCase() == "m") {
            price +=
                getPrice(size.M.SellPrice, size.M.Discount) * item.Quantity;
          } else {
            price +=
                getPrice(size.S.SellPrice, size.S.Discount) * item.Quantity;
          }
          break; // Exit the inner loop once the size is found
        }
      }
    }

    return price;
  }

  void updateCartQuantity(String cartId, int quantity) {
    final DatabaseReference cartRef = FirebaseDatabase.instance
        .ref()
        .child('Carts')
        .child(getUserUID())
        .child(cartId);
    if (quantity > 0) {
      cartRef.update({'Quantity': quantity}).then((_) {
        print("Successfully updated quantity");
      }).catchError((error) {
        print("Failed to update quantity: $error");
      });
    } else {
      cartRef.remove().then((_) {
        print("Successfully removed product");
      }).catchError((error) {
        print("Failed to remove product: $error");
      });
    }
  }

  int totalPrice = 0;
  int? discountValue = 0;
  List<Discount> discounts = [];
  List<CartDetail> carts = [];
  List<Product> products = [];
  List<ProductSize> productSizes = [];
  List<Product> filteredProducts = [];
  List<ProductSize> filteredSizes = [];
  List<Discount> validDiscounts = [];

  @override
  void initState() {
    super.initState();
    userCartDbRef = FirebaseDatabase.instance
        .ref()
        .child("Carts")
        .child(FirebaseAuth.instance.currentUser!.uid);

    // Fetching data from Firebase and updating state
    discountDbRef.onValue.listen((event) {
      setState(() {
        if (this.mounted) {
          discounts = event.snapshot.children
              .map((snapshot) {
                return Discount.fromSnapshot(snapshot);
              })
              .where((element) => element.Status == 0 && element.Uses != 0)
              .toList();
        }
      });
    });

    userCartDbRef.onValue.listen((event) {
      if (this.mounted) {
        setState(() {
          carts = event.snapshot.children
              .map((snapshot) {
                return CartDetail.fromSnapshot(snapshot);
              })
              .where((element) => element.Stt == 0)
              .toList();
        });
      }
    });

    productsDbRef.onValue.listen((event) {
      if (this.mounted) {
        setState(() {
          products = event.snapshot.children
              .map((snapshot) {
                return Product.fromSnapshot(snapshot);
              })
              .where((element) => element.Status == 0)
              .toList();
        });
      }
    });

    productSizesDbRef.onValue.listen((event) {
      if (this.mounted) {
        setState(() {
          productSizes = event.snapshot.children
              .map((snapshot) {
                return ProductSize.fromSnapshot(snapshot);
              })
              .where((element) =>
                  element.S.Status == 0 ||
                  element.M.Status == 0 ||
                  element.L.Status == 0)
              .toList();
        });
      }
    });
  }

  String formatCurrency(int value) {
    final formatter = NumberFormat.decimalPattern('vi');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    filteredProducts.clear();
    filteredSizes.clear();

    carts.forEach((item) {
      products.forEach((pro) {
        if (item.ID_Product == pro.ID_Product) {
          filteredProducts.add(pro);
        }
      });
    });
    filteredProducts.forEach((pro) {
      productSizes.forEach((size) {
        if (size.S.ID_Product == pro.ID_Product) {
          filteredSizes.add(size);
        }
      });
    });

    // Calculating valid discounts based on total price
    validDiscounts = discounts
        .where((discount) =>
            discount.Required < getTotalPrice(carts, productSizes))
        .toList();

    // Ensure discountValue is valid
    if (validDiscounts.isNotEmpty &&
        !validDiscounts.any((d) => d.Price == discountValue)) {
      discountValue = validDiscounts.first.Price;
    }

    totalPrice = 0;
    totalPrice = getTotalPrice(carts, filteredSizes);

    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
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
              Color.fromRGBO(231, 227, 227, 1),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              width: MediaQuery.of(context).size.width / 2 + 166,
              height: MediaQuery.of(context).size.height - 350,
              child: ListView.builder(
                itemCount: carts.length,
                itemBuilder: (context, index) {
                  if (index >= filteredProducts.length ||
                      index >= filteredSizes.length) {
                    return Container(); // Return an empty container if index is out of bounds
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(pro: filteredProducts[index])));
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      width: MediaQuery.of(context).size.width / 2 + 153,
                      height: 130,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                            width: 100,
                            height: 100,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(width: 2.0)),
                            child: Image.network(
                              filteredProducts[index].Image_Url[0]!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 + 25,
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filteredProducts[index]
                                          .Product_Name
                                          .toString() +
                                      " - " +
                                      carts[index].ID_ProductSize,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Text(
                                  filteredProducts[index].Category,
                                  style: TextStyle(fontSize: 13),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                ),
                                Text(
                                  carts[index].ID_ProductSize == "S"
                                      ? formatCurrency(getPrice(
                                                  filteredSizes[index]
                                                      .S
                                                      .SellPrice,
                                                  filteredSizes[index]
                                                      .S
                                                      .Discount))
                                              .toString() +
                                          " VND"
                                      : carts[index].ID_ProductSize == "M"
                                          ? formatCurrency(getPrice(
                                                      filteredSizes[index]
                                                          .M
                                                          .SellPrice,
                                                      filteredSizes[index]
                                                          .M
                                                          .Discount))
                                                  .toString() +
                                              " VND"
                                          : formatCurrency(getPrice(
                                                      filteredSizes[index]
                                                          .L
                                                          .SellPrice,
                                                      filteredSizes[index]
                                                          .L
                                                          .Discount))
                                                  .toString() +
                                              " VND",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (carts[index].Quantity >
                                                        0) {
                                                      carts[index].Quantity -=
                                                          1;
                                                      updateCartQuantity(
                                                          carts[index].ID_Cart,
                                                          carts[index]
                                                              .Quantity);
                                                      totalPrice =
                                                          getTotalPrice(carts,
                                                              filteredSizes);
                                                    }
                                                  });
                                                },
                                                icon: Icon(Icons.remove,
                                                    color: Colors.white,
                                                    size: 20)),
                                          ),
                                          Container(
                                            width: 20,
                                            margin: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Text(
                                              carts[index].Quantity.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            width: 36,
                                            height: 36,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    // kiểm tra số lượng tồn
                                                    if (carts[index]
                                                            .ID_ProductSize ==
                                                        "S") {
                                                      if (carts[index]
                                                              .Quantity <
                                                          filteredSizes[index]
                                                              .S
                                                              .Stock) {
                                                        carts[index].Quantity +=
                                                            1;
                                                        updateCartQuantity(
                                                            carts[index]
                                                                .ID_Cart,
                                                            carts[index]
                                                                .Quantity);
                                                      }
                                                    } else if (carts[index]
                                                            .ID_ProductSize ==
                                                        "M") {
                                                      if (carts[index]
                                                              .Quantity <
                                                          filteredSizes[index]
                                                              .M
                                                              .Stock) {
                                                        carts[index].Quantity +=
                                                            1;
                                                        updateCartQuantity(
                                                            carts[index]
                                                                .ID_Cart,
                                                            carts[index]
                                                                .Quantity);
                                                      }
                                                    } else if (carts[index]
                                                            .ID_ProductSize ==
                                                        "L") {
                                                      if (carts[index]
                                                              .Quantity <
                                                          filteredSizes[index]
                                                              .L
                                                              .Stock) {
                                                        carts[index].Quantity +=
                                                            1;
                                                        updateCartQuantity(
                                                            carts[index]
                                                                .ID_Cart,
                                                            carts[index]
                                                                .Quantity);
                                                      }
                                                    }

                                                    totalPrice = getTotalPrice(
                                                        carts, filteredSizes);
                                                  });
                                                },
                                                icon: Icon(Icons.add,
                                                    color: Colors.white,
                                                    size: 20)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 155,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(207, 207, 207, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 5, 0, 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                width: MediaQuery.of(context).size.width - 124,
                                child: Text(
                                  "Discount:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              DropdownButton<String>(
                                value: discountValue.toString(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    discountValue = int.parse(newValue!);
                                  });
                                },
                                items: validDiscounts
                                    .map((Discount validDiscounts) {
                                  return DropdownMenuItem<String>(
                                      value: validDiscounts.Price.toString(),
                                      child: Text(
                                          validDiscounts.Price.toString()));
                                }).toList(),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 124,
                                child: Text(
                                  "Total:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              Text(
                                "${formatCurrency(totalPrice - discountValue! < 0 ? 0 : totalPrice - discountValue!)}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 75,
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () {
                            if (filteredProducts.isEmpty) {
                              MsgDialog.MSG(context, "Error",
                                  "No products in cart to checkout");
                            } else {
                              // TODO: Implement checkout logic
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartDetails(
                                    TotalPrice: totalPrice,
                                    Discount: discountValue!,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Checkout",
                            style: TextStyle(color: Colors.black),
                          )),
                    )
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
