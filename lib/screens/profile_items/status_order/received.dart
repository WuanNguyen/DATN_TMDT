import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/screens/profile_items/status_order/detail_received.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Received extends StatefulWidget {
  const Received({super.key});

  @override
  State<Received> createState() => _ReceivedState();
}

class _ReceivedState extends State<Received> {
  String imageUser =
      "https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a";

  List<Order> order = [];
  Map<String, Users> userCache = {};

  Future<Users> getUserInfo(String userId) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Users').child(userId);
    DataSnapshot snapshot = await userRef.get();
    return Users.fromSnapshot(snapshot);
  }

  String getUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) return user.uid.toString();
    return "";
  }

  @override
  void initState() {
    super.initState();
    String ID = getUserUID();
    print(ID);
    final DatabaseReference Orders_dbRef =
        FirebaseDatabase.instance.ref().child('Order');

    Orders_dbRef.onValue.listen((event) {
      if (mounted) {
        setState(() {
          order = event.snapshot.children
              .map((snapshot) {
                return Order.fromSnapshot(snapshot);
              })
              .where(
                (element) =>
                    element.Order_Status == 'dagiao' && element.ID_User == ID,
              )
              .toList();
        });

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
                        'No orders have been completed',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: order.length,
                            itemBuilder: (context, index) {
                              final item = order[index];

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 233, 249, 255),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 203, 202, 202)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    fontWeight: FontWeight.bold,
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
                                                    fontWeight: FontWeight.bold,
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
                                                    fontWeight: FontWeight.bold,
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: order[index]
                                                      .Total_Price
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: order[index]
                                                      .Payment
                                                      .toString(),
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
                                            order[index].Order_Date.toString(),
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailReceived(
                                                        orderId: order[index]
                                                            .ID_Order),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Detail',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
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
          )
        ],
      ),
    );
  }
}
