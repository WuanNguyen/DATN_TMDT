import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountUser extends StatefulWidget {
  const AccountUser({super.key});

  @override
  State<AccountUser> createState() => _AccountUserState();
}

class _AccountUserState extends State<AccountUser> {
  String imageUser =
      "https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a";

  final DatabaseReference Users_dbRef =
      FirebaseDatabase.instance.ref().child('Users');

  List<Users> users = [];
  void _updateStatus(Users item) {
    Users_dbRef.child(item.ID_User).update({'Status': 1}).then((_) {
      print("Successfully updated status");
    }).catchError((error) {
      print("Failed to update status: $error");
    });
  }

  String sortBy = 'Username';
  void sortUser() {
    if (sortBy == 'Username') {
      users.sort((a, b) => a.Username!.compareTo(b.Username!));
    }
  }

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
    Users_dbRef.onValue.listen((event) {
      if (mounted) {
        setState(() {
          users = event.snapshot.children
              .map((snapshot) {
                return Users.fromSnapshot(snapshot);
              })
              .where(
                (element) => element.Status == 0 && element.Role == 'user',
              )
              .toList();

          // Kiểm tra kích thước của danh sách
          print('Order list length: ${users.length}');
        });
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
          Positioned(
            top: 20, // Adjust the top position as needed
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          sortBy = 'Username';
                          sortUser();
                        });
                      }
                    },
                    child: const Text('Sort by name'),
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('bought'),
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('canceled '),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 70, // Adjust the top position to be below the Row
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
                child: users.isEmpty
                    ? const Center(
                        child: Text(
                          'No User',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final item = users[index];
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
                                                    text: 'Name: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.Username,
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
                                                    text: item.Address,
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
                                                    text: item.Phone,
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
                                                    text: 'Role: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item.Role,
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
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         DetailConfirm(
                                              //             orderId: order[index]
                                              //                 .ID_Order),
                                              //   ),
                                              // );
                                            },
                                            child: const Text(
                                              'Detail',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              NotiDialog.show(
                                                  context,
                                                  'Notification',
                                                  'Do you want to delete this account?',
                                                  () {
                                                _updateStatus(item);
                                              }, () {});

                                              // NotiDialog.show(
                                              //     context,
                                              //     'Notification',
                                              //     'You definitely want to cancel your order',
                                              //     () {
                                              //   _updateStatus(item.ID_Order);
                                              //   dialogBottom.ShowBottom(context,
                                              //       'Order has been cancelled');
                                              // }, () {});
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
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
