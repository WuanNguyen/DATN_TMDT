import 'dart:ffi';

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
  Discount selectedDiscount = Discount(
      Description: "", id: "", Uses: 0, Price: 0, Required: 0, Status: 0);

  String selectedDiscountID = "Discount0";

  String getUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) return user.uid.toString();
    return "";
  }

  int getPrice(int sellPrice, int discountPrice) {
    return sellPrice - discountPrice;
  }

  String formatCurrency(int value) {
    final formatter = NumberFormat.decimalPattern('vi');
    return formatter.format(value);
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
  int discountValue = 0;
  List<Discount> discounts = [];
  List<CartDetail> carts = [];
  List<Product> products = [];
  List<ProductSize> productSizes = [];
  List<Product> filteredProducts = [];
  List<ProductSize> filteredSizes = [];
  List<Discount> validDiscounts = [];

  Future<void> fetchDiscounts() async {
    final event = await discountDbRef.once();
    try {
      if (this.mounted) {
        setState(() {
          if (!mounted) return;
          discounts = event.snapshot.children
              .map((snapshot) {
                return Discount.fromSnapshot(snapshot);
              })
              .where((element) => element.Status == 0 && element.Uses != 0)
              .toList();
          if (discounts.isNotEmpty) {
            discountValue = int.parse(discounts[0].Price.toString());
          }
        });
      }
    } catch (e) {
      print("Error at fetchDiscounts()");
    }
  }

  @override
  void initState() {
    super.initState();
    userCartDbRef = FirebaseDatabase.instance
        .ref()
        .child("Carts")
        .child(FirebaseAuth.instance.currentUser!.uid);

    // Fetching data from Firebase and updating state
    fetchDiscounts();

    userCartDbRef.onValue.listen((event) {
      if (this.mounted) {
        setState(() {
          if (!mounted) return;
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
          if (!mounted) return;
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
          if (!mounted) return;
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
            discount.Required <= getTotalPrice(carts, productSizes))
        .toList();

    // Ensure discountValue is valid
    if (validDiscounts.isNotEmpty &&
        !validDiscounts.any((d) => d.Price == discountValue)) {
      discountValue = validDiscounts.first.Price;
    }

    totalPrice = 0;
    totalPrice = getTotalPrice(carts, filteredSizes);
    setState(() {
      if (totalPrice < selectedDiscount.Required)
        selectedDiscount = validDiscounts[0];
    });

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
                          border: Border.all(
                              color: Color.fromARGB(255, 172, 170, 170)),
                          color: Color.fromARGB(59, 179, 177, 177),
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
                                color: Color.fromARGB(105, 255, 255, 255),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 143, 143, 143),
                                    width: 1)),
                            child: Image.network(
                              filteredProducts[index].Image_Url[0],
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
                                              filteredSizes[index].S.SellPrice,
                                              filteredSizes[index]
                                                  .S
                                                  .Discount)) +
                                          " VND"
                                      : carts[index].ID_ProductSize == "M"
                                          ? formatCurrency(getPrice(
                                                  filteredSizes[index]
                                                      .M
                                                      .SellPrice,
                                                  filteredSizes[index]
                                                      .M
                                                      .Discount)) +
                                              " VND"
                                          : formatCurrency(getPrice(
                                                  filteredSizes[index]
                                                      .L
                                                      .SellPrice,
                                                  filteredSizes[index]
                                                      .L
                                                      .Discount)) +
                                              " VND",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 104, 104, 104),
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
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: IconButton(
                                                onPressed: () {
                                                  if (mounted) {
                                                    setState(() {
                                                      if (carts[index]
                                                              .Quantity >
                                                          0) {
                                                        if (totalPrice <
                                                            selectedDiscount
                                                                .Required)
                                                          selectedDiscount =
                                                              validDiscounts[0];
                                                        carts[index].Quantity -=
                                                            1;
                                                        updateCartQuantity(
                                                            carts[index]
                                                                .ID_Cart,
                                                            carts[index]
                                                                .Quantity);
                                                        totalPrice =
                                                            getTotalPrice(carts,
                                                                filteredSizes);
                                                      }
                                                    });
                                                  }
                                                },
                                                icon: Icon(Icons.remove,
                                                    color: Color.fromRGBO(
                                                        48, 50, 52, 1),
                                                    size: 22)),
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
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: IconButton(
                                                onPressed: () {
                                                  if (mounted) {
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
                                                          carts[index]
                                                              .Quantity += 1;
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
                                                          carts[index]
                                                              .Quantity += 1;
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
                                                          carts[index]
                                                              .Quantity += 1;
                                                          updateCartQuantity(
                                                              carts[index]
                                                                  .ID_Cart,
                                                              carts[index]
                                                                  .Quantity);
                                                        }
                                                      }

                                                      totalPrice =
                                                          getTotalPrice(carts,
                                                              filteredSizes);
                                                    });
                                                  }
                                                },
                                                icon: Icon(Icons.add,
                                                    color: Color.fromRGBO(
                                                        48, 50, 52, 1),
                                                    size: 22)),
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
                    color: Color.fromARGB(59, 179, 177, 177),
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
                          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Discount:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text(
                                    "${formatCurrency(selectedDiscount.Price)} VND"),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (mounted) {
                                    selectedDiscountID =
                                        (await showDiscountDialog(
                                            context, validDiscounts))!;
                                    setState(() {
                                      selectedDiscount =
                                          validDiscounts.firstWhere(
                                        (element) =>
                                            element.id == selectedDiscountID,
                                      );
                                      print(selectedDiscount.Price);
                                    });
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: Text(
                                    "More",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 84, 38, 77),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Total:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
                                child: Text(
                                  "${totalPrice - selectedDiscount.Price! < 0 ? 0 : formatCurrency(totalPrice - selectedDiscount.Price!)} VND",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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
                                    idDiscount: selectedDiscountID,
                                    TotalPrice: totalPrice,
                                    Discount: selectedDiscount.Price!,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Checkout",
                            style: TextStyle(
                                color: Color.fromARGB(255, 104, 104, 104)),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String?> showDiscountDialog(
      BuildContext context, List<Discount> discount) async {
    final String? selectedId = await showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.0),
          ),
          child: Container(
            height: 700,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.0, 0.7, 1],
                transform: GradientRotation(50),
                colors: [
                  Color.fromRGBO(54, 171, 237, 0.80),
                  Color.fromRGBO(149, 172, 205, 0.75),
                  Color.fromRGBO(244, 173, 173, 0.1),
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                  child: const Text(
                    "Select Discount",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: validDiscounts.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 200,
                        height: 75,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context, validDiscounts[index].id);
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1.0),
                            ),
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            width: 100,
                            height: 40,
                            child: Text(validDiscounts[index].Description),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, selectedDiscountID);
                  },
                  child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                      child: Center(
                        child: Text("Cancel"),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
    return selectedId;
  }
}
