import 'package:doan_tmdt/model/classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  // final DatabaseReference _databaseReference = FirebaseDatabase(
  //   databaseURL: 'https://datn-sporthuviz-bf24e-default-rtdb.firebaseio.com/',
  // ).ref();
  // List<Map<dynamic, dynamic>> lst1 = [];

  //List lst2 = [];

  // Future<void> _loadData() async {
  //   try {
  //     // Tải dữ liệu từ Firebase Realtime Database
  //     DatabaseEvent _event = await _databaseReference.once();
  //     DataSnapshot? _dataSnapshot = _event.snapshot;

  //     if (_dataSnapshot != null) {
  //       Map<dynamic, dynamic> data =
  //           (_dataSnapshot.value as Map)['OrderDetail'];

  //       // Tạo chuỗi id để so sánh
  //       String id = widget.orderId;

  //       // Duyệt qua các cặp key-value trong data
  //       data.forEach((key, value) {
  //         // Kiểm tra nếu key của mục hiện tại bằng id
  //         print(key);
  //         if (key == id) {
  //           // Thêm value (order detail) vào lst1
  //           lst1.add(value);
  //         }
  //       });
  //     }

  //     // Tạo danh sách lst2 từ các giá trị trong lst1
  //     // lst1.forEach((element) {
  //     //   lst2.add(element.values);
  //     // });

  //     // Cập nhật giao diện nếu cần
  //     setState(() {
  //       // Các thao tác cập nhật giao diện ở đây (nếu cần)
  //     });
  //   } catch (e) {
  //     // Xử lý lỗi nếu có
  //     print(e.toString());
  //   }

  //   // In ra màn hình console để debug
  //   print(lst1);
  //   print("------------------0");
  //   print(lst2);
  // }
  ////////////////////////////////////////

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
                        // final userName =
                        //     userCache[item.ID_User]?.Username ?? 'Loading...';
                        final picture = productCache[item.idProduct]
                                ?.Image_Url ??
                            'https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a';
                        // final address =
                        //     userCache[item.ID_User]?.Address ?? 'Loading...';

                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 233, 249, 255),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 203, 202, 202)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Độ cong của góc
                                      border: Border.all(
                                          color: Colors.black,
                                          width:
                                              2), // Đặt màu và độ rộng của viền
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Độ cong của góc cho hình ảnh
                                      child: Image.network(
                                        picture,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
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
                                      style: DefaultTextStyle.of(context).style,
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
                                      style: DefaultTextStyle.of(context).style,
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
                                      style: DefaultTextStyle.of(context).style,
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
                                        // TextSpan(
                                        //   text: order[index].Payment.toString(),
                                        //   style: TextStyle(
                                        //     fontSize: 18.0,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  // Text(
                                  //   '                                      ' +
                                  //       order[index].Order_Date.toString(),
                                  //   style: const TextStyle(
                                  //     fontSize: 15.0,
                                  //   ),
                                  // ),
                                  const SizedBox(height: 5.0),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
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
