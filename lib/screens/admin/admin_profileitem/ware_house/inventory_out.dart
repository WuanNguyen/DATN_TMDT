import 'package:doan_tmdt/model/classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class InventoryOut extends StatefulWidget {
  const InventoryOut({super.key});

  @override
  State<InventoryOut> createState() => _InventoryOutState();
}

class _InventoryOutState extends State<InventoryOut> {
  final DatabaseReference invOUT_dbRef =
      FirebaseDatabase.instance.ref().child('Warehouse').child('Inventory_out');

  List<Inventorys_out> inv_out = [];
  // void _updateStatus(Users item) {
  //   Users_dbRef.child(item.ID_User).update({'Status': 1}).then((_) {
  //     print("Successfully updated status");
  //   }).catchError((error) {
  //     print("Failed to update status: $error");
  //   });
  // }

  String sortBy = 'Date_In';
  // void sortUser() {
  //   if (sortBy == 'Username') {
  //     users.sort((a, b) => a.Username!.compareTo(b.Username!));
  //   }
  // }

  // Map<String, Users> userCache = {};
  // String sortBy = 'Order_Date'; // Biến lưu trữ tiêu chí sắp xếp

  // Future<Users> getUserInfo(String userId) async {
  //   DatabaseReference userRef =
  //       FirebaseDatabase.instance.ref().child('Users').child(userId);
  //   DataSnapshot snapshot = await userRef.get();
  //   return Users.fromSnapshot(snapshot);
  // }

  @override
  void initState() {
    super.initState();
    invOUT_dbRef.onValue.listen((event) {
      if (mounted) {
        setState(() {
          inv_out = event.snapshot.children.map((snapshot) {
            return Inventorys_out.fromSnapshot(snapshot);
          }).toList();

          // Kiểm tra kích thước của danh sách
          print('Order list length: ${inv_out.length}');
        });
        if (sortBy == 'Date_In') {
          inv_out.sort((a, b) => b.Date!.compareTo(a.Date!));
        }
        //-------------------------sắp xếp
        // Sắp xếp danh sách dựa trên tiêu chí hiện tại
        // if (sortBy == 'Order_Date') {
        //   order.sort((a, b) => b.Order_Date!.compareTo(a.Order_Date!));
        // } else if (sortBy == 'nameuser') {
        //   order.sort((a, b) => a.nameuser!.compareTo(b.nameuser!));
        // }

        // Cập nhật thông tin người dùng
        // for (var orderItem in order) {
        //   if (!userCache.containsKey(orderItem.ID_User)) {
        //     getUserInfo(orderItem.ID_User!).then((userInfo) {
        //       setState(() {
        //         userCache[orderItem.ID_User!] = userInfo;
        //       });
        //     });
        //   }
        // }
      }
    });
  }

  String formatCurrency(int value) {
    final formatter = NumberFormat.decimalPattern('vi');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
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
                child: inv_out.isEmpty
                    ? const Center(
                        child: Text(
                          'No Out',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: inv_out.length,
                              itemBuilder: (context, index) {
                                final item = inv_out[index];
                                return Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
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
                                                    text: 'Name Product: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.Product_Name,
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
                                                    text: 'Categoty: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.Category,
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
                                                    text: 'Distributor: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.Distributor_Name,
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
                                                    text: 'Import price: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${formatCurrency(item.Import_Price).toString()} VND',
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
                                                    text: 'Sell price: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${formatCurrency(item.Sell_Price).toString()} VND',
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
                                                    text: 'Size: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.Size,
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
                                                    text: 'Quantity: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.Quantity
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
                                                    text: 'Date: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.Date.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
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
                                                    text: 'Total price: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${formatCurrency(item.Sell_Price * item.Quantity).toString()} VND',
                                                    style: const TextStyle(
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
            ),
          )
        ],
      ),
    );
  }
}
