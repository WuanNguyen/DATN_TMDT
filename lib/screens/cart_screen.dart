import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:doan_tmdt/model/cart_product.dart';
import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/model/product.dart';
import 'package:doan_tmdt/screens/detail_screen.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';

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

  int getTotalPrice(
      List<CartDetail> cartDetails, List<ProductSize> productSizes) {
    int total = 0;
    cartDetails.forEach((cartDetail) {
      productSizes.forEach((productSize) {
        if (cartDetail.ID_Product == productSize.S.ID_Product) {
          total += int.parse(cartDetail.Quantity.toString()) *
              (cartDetail.ID_ProductSize == "S"
                  ? getPrice(productSize.S.SellPrice, productSize.S.Discount)
                  : cartDetail.ID_ProductSize == "M"
                      ? getPrice(
                          productSize.M.SellPrice, productSize.M.Discount)
                      : getPrice(
                          productSize.L.SellPrice, productSize.L.Discount));
        }
      });
    });
    return total;
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
      List<Discount> fetchedDiscounts = [];
      setState(() {
        if (this.mounted) {
          validDiscounts = event.snapshot.children
              .map((snapshot) {
                return Discount.fromSnapshot(snapshot);
              })
              .where((element) => element.Status == 0)
              .toList();
        }
        discounts = fetchedDiscounts
            .where((discount) => discount.Status == 0 && discount.Uses != 0)
            .toList();
        if (discounts.isNotEmpty) {
          discountValue = int.parse(discounts[0].Price.toString());
        }
      });
    });

    userCartDbRef.onValue.listen((event) {
      final List<CartDetail> fetchedCarts = [];
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
      List<Product> fetchedProducts = [];
      if (this.mounted) {
        setState(() {
          filteredProducts = event.snapshot.children
              .map((snapshot) {
                return Product.fromSnapshot(snapshot);
              })
              .where((element) => element.Status == 0)
              .toList();
        });
      }
    });

    productSizesDbRef.onValue.listen((event) {
      List<ProductSize> fetchedProductSizes = [];
      if (this.mounted) {
        setState(() {
          filteredSizes = event.snapshot.children
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
    // filteredProducts.clear();
    // filteredSizes.clear();

    // Filtering products and sizes based on cart data
    // carts.forEach((cart) {
    //   products.forEach((product) {
    //     if (product.ID_Product.toString() == cart.ID_Product.toString()) {
    //       filteredProducts.add(product);
    //     }
    //   });
    // });

    // filteredProducts.forEach((product) {
    //   productSizes.forEach((size) {
    //     if (size.L.ID_Product == product.ID_Product) {
    //       filteredSizes.add(size);
    //     }
    //   });
    // });

    // Calculating valid discounts based on total price
    validDiscounts = discounts
        .where((discount) =>
            discount.Required < getTotalPrice(carts, productSizes))
        .toList();
    totalPrice = getTotalPrice(carts, productSizes);

    print("is empty?:  ");
    print(filteredSizes.isEmpty);
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
                              filteredProducts[index].Image_Url,
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
                                      ? (filteredSizes.isNotEmpty &&
                                              index < filteredSizes.length
                                          ? getPrice(
                                                  filteredSizes[index]
                                                      .S
                                                      .SellPrice,
                                                  filteredSizes[index]
                                                      .S
                                                      .Discount)
                                              .toString()
                                          : "Size not available")
                                      : carts[index].ID_ProductSize == "M"
                                          ? (filteredSizes.isNotEmpty &&
                                                  index < filteredSizes.length
                                              ? getPrice(
                                                      filteredSizes[index]
                                                          .M
                                                          .SellPrice,
                                                      filteredSizes[index]
                                                          .M
                                                          .Discount)
                                                  .toString()
                                              : "Size not available")
                                          : (filteredSizes.isNotEmpty &&
                                                  index < filteredSizes.length
                                              ? getPrice(
                                                      filteredSizes[index]
                                                          .L
                                                          .SellPrice,
                                                      filteredSizes[index]
                                                          .L
                                                          .Discount)
                                                  .toString()
                                              : "Size not available"),
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
                                                    carts[index].Quantity += 1;
                                                    totalPrice = getTotalPrice(
                                                        carts, productSizes);
                                                  });
                                                },
                                                icon: Icon(Icons.add,
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
                                                        0)
                                                      carts[index].Quantity -=
                                                          1;
                                                    totalPrice = getTotalPrice(
                                                        carts, productSizes);
                                                  });
                                                },
                                                icon: Icon(Icons.remove,
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
                                    // discountValue = int.parse(newValue.toString());
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
                                "${totalPrice - int.parse(discountValue.toString()) < 0 ? 0 : totalPrice - int.parse(discountValue.toString())}",
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
                            print(filteredProducts.isEmpty);
                            if (filteredProducts.isEmpty) {
                              MsgDialog.MSG(context, "Error",
                                  "No products in cart to checkout");
                            } else {
                              // TODO: Implement checkout logic
                            }
                          },
                          child: Text("Checkout")),
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