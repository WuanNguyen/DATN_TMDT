import 'package:doan_tmdt/model/classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DetailConfirm extends StatefulWidget {
  const DetailConfirm({Key? key, required this.orderId}) : super(key: key);
  final String orderId;
  @override
  State<DetailConfirm> createState() => _DetailConfirmState();
}

class _DetailConfirmState extends State<DetailConfirm> {
  String image =
      "https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a";

  Map<String, Product> productCache = {};

  Future<Product> getProInfo(String proID) async {
    DatabaseReference proRef =
        FirebaseDatabase.instance.ref().child('Products').child(proID);
    DataSnapshot snapshot = await proRef.get();
    return Product.fromSnapshot(snapshot);
  }

  void _updateStatus(String id) {
    final DatabaseReference updateSTTOrder =
        FirebaseDatabase.instance.reference().child('Order');
    updateSTTOrder.child(id).update({'Order_Status': 'danggiao'}).then((_) {
      print("Successfully updated status");
    }).catchError((error) {
      print("Failed to update status: $error");
    });
  }

  List<OrderDetail> orderDetail = [];
  @override
  void initState() {
    final DatabaseReference OrderDetail_dbRef = FirebaseDatabase.instance
        .reference()
        .child('OrderDetail')
        .child(widget.orderId);

    super.initState();
    OrderDetail_dbRef.onValue.listen((event) {
      if (mounted) {
        setState(() {
          orderDetail = event.snapshot.children.map((snapshot) {
            return OrderDetail.fromSnapshot(snapshot);
          }).toList();
        });
      }

      for (var Proitem in orderDetail) {
        if (!productCache.containsKey(Proitem.idProduct)) {
          getProInfo(Proitem.idProduct!).then((proInfo) {
            setState(() {
              productCache[Proitem.idProduct!] = proInfo;
            });
          });
        }
      }
    });
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
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: orderDetail.length,
                      itemBuilder: (context, index) {
                        final item = orderDetail[index];
                        final namePro =
                            productCache[item.idProduct]?.Product_Name ??
                                'Loading...';
                        final picture = productCache[item.idProduct]
                                ?.Image_Url ??
                            'https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a';

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
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
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
                                            text: item.idProductSize,
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
                                            text: item.price.toString(),
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
                                            text: item.quantity.toString(),
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
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
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
