import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:doan_tmdt/screens/admin/admin_bottomnav.dart';
import 'package:doan_tmdt/screens/admin/admin_profileitem/title_Confirm.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminConfirm extends StatefulWidget {
  const AdminConfirm({super.key});

  @override
  State<AdminConfirm> createState() => _AdminConfirmState();
}

class _AdminConfirmState extends State<AdminConfirm> {
  String imageUser =
      "https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a";

  final DatabaseReference Orders_dbRef =
      FirebaseDatabase.instance.ref().child('Order');

  List<Order> order = [];

  Map<String, Users> userCache = {};
  String sortBy = 'Order_Date'; // Biến lưu trữ tiêu chí sắp xếp

  Future<Users> getUserInfo(String userId) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Users').child(userId);
    DataSnapshot snapshot = await userRef.get();
    return Users.fromSnapshot(snapshot);
  }

  @override
  void initState() {
    super.initState();
    Orders_dbRef.onValue.listen((event) {
      if (mounted) {
        setState(() {
          order = event.snapshot.children
              .map((snapshot) {
                return Order.fromSnapshot(snapshot);
              })
              .where(
                (element) => element.Order_Status == 'xacnhan',
              )
              .toList();

          // Kiểm tra kích thước của danh sách
          print('Order list length: ${order.length}');
        });
        //-------------------------sắp xếp
        // Sắp xếp danh sách dựa trên tiêu chí hiện tại
        if (sortBy == 'Order_Date') {
          order.sort((a, b) => b.Order_Date!.compareTo(a.Order_Date!));
        } else if (sortBy == 'nameuser') {
          order.sort((a, b) => a.nameuser!.compareTo(b.nameuser!));
        }

        // Cập nhật thông tin người dùng
        for (var orderItem in order) {
          if (!userCache.containsKey(orderItem.ID_User)) {
            getUserInfo(orderItem.ID_User!).then((userInfo) {
              setState(() {
                userCache[orderItem.ID_User!] = userInfo;
              });
            });
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
          'Confirm Order',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminBottomnav(index: 2)),
            );
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
            child: Container(
              width: double.infinity,
              child: order.isEmpty
                  ? const Center(
                      child: Text(
                        'No orders to confirm',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    sortBy = 'nameuser';
                                    order.sort((a, b) =>
                                        a.nameuser!.compareTo(b.nameuser!));
                                  });
                                },
                                child: const Text('sort by name')),
                            const SizedBox(
                              width: 20,
                            ),
                            OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    sortBy = 'Order_Date';
                                    order.sort((a, b) =>
                                        a.Order_Date!.compareTo(b.Order_Date!));
                                  });
                                },
                                child: const Text('Sort by time of order'))
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: order.length,
                            itemBuilder: (context, index) {
                              // Kiểm tra chỉ mục hợp lệ
                              if (index >= 0 && index < order.length) {
                                final item = order[index];

                                final picture = userCache[item.ID_User]
                                        ?.Image_Url ??
                                    'https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a';

                                return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(59, 179, 177, 177),
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 131, 131, 131)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: ClipOval(
                                              child: Image.network(
                                                picture,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (item.ID_Order != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TitleConfirm(
                                                            orderId:
                                                                item.ID_Order),
                                                  ),
                                                );
                                              } else {
                                                // Xử lý trường hợp nếu item.ID_Order là null
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Order ID is null.'),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text(
                                              'Detail',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  const TextSpan(
                                                    text: 'Name: ',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.nameuser,
                                                    style: const TextStyle(
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
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  const TextSpan(
                                                    text: 'Address: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.addressuser,
                                                    style: const TextStyle(
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
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  const TextSpan(
                                                    text: 'Phone: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.phoneuser,
                                                    style: const TextStyle(
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
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  const TextSpan(
                                                    text: 'Total Price: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${formatCurrency(item.Total_Price)} VND'
                                                            .toString(),
                                                    style: const TextStyle(
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
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  const TextSpan(
                                                    text: 'Payment: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        item.Payment.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              '                            ' +
                                                  item.Order_Date.toString(),
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox
                                    .shrink(); // Trả về widget trống nếu chỉ mục không hợp lệ
                              }
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
