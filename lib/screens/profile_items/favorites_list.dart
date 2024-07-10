import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FavoritesList extends StatefulWidget {
  const FavoritesList({Key? key}) : super(key: key);

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  Query ProductSizes_dbRef =
      FirebaseDatabase.instance.ref().child('ProductSizes');
  List<ProductSize> sizes = [];
  List<ProductSize> filteredSizes = [];

  List<Favorite> favo = [];
  String getUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) return user.uid.toString();
    return "";
  }

  int getPrice(int SellPrice, int Discount) {
    return SellPrice - Discount;
  }

  Future<Product> getProInfo(String proID) async {
    DatabaseReference proRef =
        FirebaseDatabase.instance.ref().child('Products').child(proID);
    DataSnapshot snapshot = await proRef.get();
    return Product.fromSnapshot(snapshot);
  }

  Map<String, Product> productCache = {};

  void _updateStatus(String idUser, String id) async {
    final _databaseReference = FirebaseDatabase.instance.reference();

    await _databaseReference
        .child('Favorites')
        .child(idUser)
        .child(id)
        .remove();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Removed from favorites'),
      backgroundColor: const Color.fromARGB(255, 153, 153, 153),
    ));

    // final DatabaseReference updateSTTOrder =
    //     FirebaseDatabase.instance.reference().child('Favorites');
    // updateSTTOrder.child(idUser).child(id).update({'Status': 1}).then((_) {
    //   print("Successfully updated status");
    // }).catchError((error) {
    //   print("Failed to update status: $error");
    // });
  }

  @override
  void initState() {
    super.initState();
    String ID = getUserUID();

    final DatabaseReference favorite_dbRef =
        FirebaseDatabase.instance.ref().child('Favorites').child(ID);

    favorite_dbRef.onValue.listen((event) {
      if (mounted) {
        setState(() {
          favo = event.snapshot.children
              .map((snapshot) {
                return Favorite.fromSnapshot(snapshot);
              })
              .where(
                (element) => element.Status == 0,
              )
              .toList();
        });

        for (var Proitem in favo) {
          if (!productCache.containsKey(Proitem.ID_Product)) {
            getProInfo(Proitem.ID_Product!).then((proInfo) {
              setState(() {
                productCache[Proitem.ID_Product!] = proInfo;
              });
            });
          }
        }
      }
    });

    ProductSizes_dbRef.onValue.listen((event) {
      if (this.mounted) {
        setState(() {
          sizes = event.snapshot.children.map((snapshot) {
            return ProductSize.fromSnapshot(snapshot);
          }).toList();
        });
      }

      for (var fav in favo) {
        for (var size in sizes) {
          if (fav.ID_Product == size.S.ID_Product) {
            filteredSizes.add(size);
          }
        }
      }
    });
  }

  String formatCurrency(int value) {
    final formatter = NumberFormat.decimalPattern('vi');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites list',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromRGBO(201, 241, 248, 1),
      ),
      body: Stack(
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
              ),
            ),
            child: favo.isEmpty
                ? Center(
                    child: Text(
                      'No favorites found',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: favo.length,
                      itemBuilder: (context, index) {
                        final item = favo[index];
                        final namePro =
                            productCache[item.ID_Product]?.Product_Name ??
                                'Loading...';
                        final cate = productCache[item.ID_Product]?.Category ??
                            'Loading...';
                        final picture = productCache[item.ID_Product]
                                ?.Image_Url[0] ??
                            'https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a';

                        // Check if index is within the range of filteredSizes
                        final priceText = (index < filteredSizes.length)
                            ? "${formatCurrency(getPrice(filteredSizes[index].S.SellPrice, filteredSizes[index].S.Discount))} - ${formatCurrency(getPrice(filteredSizes[index].L.SellPrice, filteredSizes[index].L.Discount))} VND"
                            : "Loading...";

                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 233, 249, 255),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 203, 202, 202)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.network(
                                  picture,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        namePro,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        cate,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      Text(
                                        priceText,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        NotiDialog.show(context, 'Notification',
                                            'You want to remove the product from your favorites list',
                                            () {
                                          _updateStatus(
                                              getUserUID(), item.ID_Product);
                                          dialogBottom.ShowBottom(context,
                                              'product has been removed');
                                        }, () {});
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        //Chuyển tới màng hình detail
                                      },
                                      child: Text(
                                        'Title',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
