import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:doan_tmdt/screens/admin/admin_profileitem/admin_confirm.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TitleConfirm extends StatefulWidget {
  const TitleConfirm({Key? key, required this.orderId}) : super(key: key);
  final String orderId;
  @override
  State<TitleConfirm> createState() => _TitleConfirmState();
}

class _TitleConfirmState extends State<TitleConfirm> {
  String image =
      "https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a";

  Map<String, Product> productCache = {};

  Future<Product> getProInfo(String proID) async {
    DatabaseReference proRef =
        FirebaseDatabase.instance.ref().child('Products').child(proID);
    DataSnapshot snapshot = await proRef.get();
    return Product.fromSnapshot(snapshot);
  }

  // lấy nhà phân phối
  Future<Distributors> getDistributorInfo(String distributorId) async {
    DatabaseReference distributorRef = FirebaseDatabase.instance
        .ref()
        .child('Distributors')
        .child(distributorId);
    DataSnapshot snapshot = await distributorRef.get();

    if (snapshot.exists) {
      return Distributors.fromSnapshot(snapshot);
    } else {
      throw Exception("Distributor not found");
    }
  }

  //lấy size detail
  Future<ProductSizeDetail> getSizeProductDetail(
      String productId, String size) async {
    DatabaseReference sizeProductRef =
        FirebaseDatabase.instance.ref().child('ProductSizes').child(productId);
    DataSnapshot snapshot = await sizeProductRef.get();
    ProductSize productSize = ProductSize.fromSnapshot(snapshot);

    switch (size) {
      case 'L':
        return productSize.L;
      case 'M':
        return productSize.M;
      case 'S':
        return productSize.S;
      default:
        throw Exception("Invalid size: $size");
    }
  }

  void _updateStatus(String id) async {
    final DatabaseReference updateSTTOrder =
        FirebaseDatabase.instance.reference().child('Order');

    try {
      await updateSTTOrder.child(id).update({'Order_Status': 'danggiao'});
      print("Successfully updated status");

      for (var item in orderDetail) {
        try {
          var sizeDetail =
              await getSizeProductDetail(item.idProduct!, item.idProductSize);
          var distributorInfo = await getDistributorInfo(
            productCache[item.idProduct]!.ID_Distributor,
          );
          await addInventory_out(
            item.idProduct!,
            productCache[item.idProduct]!.Product_Name,
            productCache[item.idProduct]!.Category,
            distributorInfo.Distributor_Name,
            sizeDetail.ImportPrice,
            sizeDetail.SellPrice,
            item.quantity,
            item.idProductSize,
          );
          print("Successfully added to inventory: ${item.idProductSize}");
        } catch (e) {
          print(
              "Error updating inventory for product ${item.idProduct} with size ${item.idProductSize}: $e");
        }
      }
    } catch (error) {
      print("Failed to update status: $error");
    }
  }

  void _updateStatusCancel(String id) {
    final DatabaseReference updateSTTOrder =
        FirebaseDatabase.instance.reference().child('Order');
    updateSTTOrder.child(id).update({'Order_Status': 'dahuy'}).then((_) {
      print("Successfully updated status");
    }).catchError((error) {
      print("Failed to update status: $error");
    });
  }

  List<OrderDetail> orderDetail = [];
  // Quản lý xuất kho------------------------------------
  Future<void> addInventory_out(
    String idpro,
    String proname,
    String cate,
    String iddis,
    int impr,
    int selpr,
    int qtity,
    String siz,
  ) async {
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();

    DataSnapshot snapshot =
        await _databaseReference.child('Max').child('MaxInventory_out').get();

    int currentUID = snapshot.exists ? snapshot.value as int : 0;
    int newUID = currentUID + 1;
    String UIDC = 'out_$siz$newUID';
    await _databaseReference
        .child('Warehouse')
        .child('Inventory_out')
        .child(UIDC)
        .set(
      {
        'ID_Product': idpro,
        'Product_Name': proname,
        'Date_In': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
        'Distributor_Name': iddis,
        'Category': cate,
        'Import_Price': impr,
        'Sell_Price': selpr,
        'Quantity': qtity,
        'size': siz
      },
    );
    await _databaseReference.child('Max').child('MaxInventory_out').set(newUID);
  }

  String formatCurrency(int value) {
    final formatter = NumberFormat.decimalPattern('vi');
    return formatter.format(value);
  }

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

  //---------------------------------------
  @override
  Widget build(BuildContext context) {
    //print(widget.orderId);
    print('----------------------------');
    print(orderDetail.length.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm Order',
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
                                ?.Image_Url[0] ??
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
                                            text:
                                                '${formatCurrency(item.price)} VND'
                                                    .toString(),
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
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () {
                                _updateStatusCancel(widget.orderId);
                                NotiDialog.showok(context, 'Notification',
                                    'Order successfully canceled', () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AdminConfirm(), // Sử dụng ID của đơn hàng
                                    ),
                                  );
                                });
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () {
                                _updateStatus(widget.orderId);
                                NotiDialog.showok(context, 'Notification',
                                    'Order has been successfully confirmed',
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AdminConfirm(), // Sử dụng ID của đơn hàng
                                    ),
                                  );
                                });
                              },
                              child: Text(
                                'Confirm',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
