import 'package:doan_tmdt/model/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CartDetails extends StatefulWidget {
  CartDetails({Key? key,required this.TotalPrice,required this.Discount}) : super(key: key);
  int TotalPrice;// tong tien
  int Discount;// ap dung giam gia

  @override
  State<CartDetails> createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetails> {
  int selectedRadio = 1;
  void setSelectedRadio(int value) {
    setState(() {
      selectedRadio = value;
    });
  }

  String image =
      "https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a";
  Map<String, Product> productCache = {};
  Map<String, ProductSize> sizeCache = {};

  String getUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) return user.uid.toString();
    return "";
  }

  Future<Product> getProInfo(String proID) async {
    DatabaseReference proRef =
        FirebaseDatabase.instance.ref().child('Products').child(proID);
    DataSnapshot snapshot = await proRef.get();
    return Product.fromSnapshot(snapshot);
  }

  Future<Users> getUserInfo(String userId) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Users').child(userId);
    DataSnapshot snapshot = await userRef.get();
    return Users.fromSnapshot(snapshot);
  }

  Future<ProductSize> getSizeInfo(String sizeID) async {
    DatabaseReference sizeRef =
        FirebaseDatabase.instance.ref().child('ProductSizes').child(sizeID);
    DataSnapshot snapshot = await sizeRef.get();
    return ProductSize.fromSnapshot(snapshot);
  }

  List<CartDetail> _cartdetail = [];
  Users? currentUser;

  @override
  void initState() {
    super.initState();
    String ID = getUserUID();

    final DatabaseReference CartDetail_dbRef =
        FirebaseDatabase.instance.ref().child('Carts').child(ID);

    CartDetail_dbRef.onValue.listen((event) {
      if (mounted) {
        setState(() {
          _cartdetail = event.snapshot.children
              .map((snapshot) {
                return CartDetail.fromSnapshot(snapshot);
              })
              .where((element) => element.Stt == 0)
              .toList();
        });

        for (var Proitem in _cartdetail) {
          if (!productCache.containsKey(Proitem.ID_Product)) {
            getProInfo(Proitem.ID_Product!).then((proInfo) {
              setState(() {
                productCache[Proitem.ID_Product!] = proInfo;
              });
            });
          }
        }

        for (var Sizeitem in _cartdetail) {
          if (!productCache.containsKey(Sizeitem.ID_Product)) {
            getSizeInfo(Sizeitem.ID_Product!).then((sizeInfo) {
              setState(() {
                sizeCache[Sizeitem.ID_Product!] = sizeInfo;
              });
            });
          }
        }

        getUserInfo(ID).then((userInfo) {
          setState(() {
            currentUser = userInfo;
          });
        });
      }
    });
  }

  int getProPrice(int SellPrice, int Discount){
    return SellPrice - Discount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'order details',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color.fromRGBO(201, 241, 248, 1),
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
            child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: _cartdetail.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = _cartdetail[index];
                        final namePro =
                            productCache[item.ID_Product]?.Product_Name ??
                                'Loading...';
                        final picture =
                            productCache[item.ID_Product]?.Image_Url ?? image;
                        final sizePrice = item.ID_ProductSize == "S" ?
                            sizeCache[item.ID_Product]?.S.SellPrice.toString() ?? 'Loading...' 
                            : item.ID_ProductSize == "M" ? 
                            sizeCache[item.ID_Product]?.M.SellPrice.toString() ?? 'Loading...'
                            : sizeCache[item.ID_Product]?.L.SellPrice.toString() ?? 'Loading...';

                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          color: Colors.black, width: 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        picture,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Name Product: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: namePro,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Size: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: item.ID_ProductSize,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Price: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: sizePrice,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Quantity: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: item.Quantity.toString(),
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.all(15),
                        height: MediaQuery.of(context).size.height / 2.5,
                        width: double.infinity,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentUser?.Username ?? 'Loading...',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          currentUser?.Address ?? 'Loading...',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Total Price: ",
                                          style: TextStyle(
                                            fontSize: 18,
                                            )),
                                        Expanded(child: Container()),
                                        Text(widget.TotalPrice.toString() + " VND",
                                          style: TextStyle(
                                            fontSize: 18,
                                            )),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Text(
                                          "Discount: ",
                                          style: TextStyle(
                                            fontSize: 18,
                                            )),
                                        Expanded(child: Container()),
                                        Text(widget.Discount.toString() + " VND",
                                          style: TextStyle(
                                            fontSize: 18,)),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Text(
                                          "Pay: ",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                        Expanded(child: Container()),
                                        Text("${widget.TotalPrice - widget.Discount} VND",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                  
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Text("Payment:",
                                    style: TextStyle(
                                      fontSize: 18,)),
                                  Radio(
                                    value: 1,
                                    groupValue: selectedRadio,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedRadio = value as int;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Cash',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Radio(
                                    value: 2,
                                    groupValue: selectedRadio,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedRadio = value as int;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Momo',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.8,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Buy',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}