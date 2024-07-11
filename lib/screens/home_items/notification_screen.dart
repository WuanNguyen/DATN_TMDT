import 'package:flutter/material.dart';
import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:doan_tmdt/screens/profile_items/status_order/detail_confirm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
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

  Future<void> getInfoNotification(String userId) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Notifications').child(userId);
    DataSnapshot snapshot = await userRef.get();

    if (snapshot.exists) {
      List<Map<String, dynamic>> tempNotifications = [];

      for (var child in snapshot.children) {
        final notificationData = Map<String, dynamic>.from(child.value as Map);
        tempNotifications.add(notificationData);
      }

      // Sort notifications by DateTime
      tempNotifications.sort((a, b) {
        String dateTimeStrA = a['Date_time'];
        String dateTimeStrB = b['Date_time'];
        return _compareDateTimeStrings(dateTimeStrA, dateTimeStrB);
      });

      setState(() {
        notifications = tempNotifications;
      });
    } else {
      print("No notifications found for user: $userId");
    }
  }

  int _compareDateTimeStrings(String dateTimeStrA, String dateTimeStrB) {
    // Example comparison of '11/07/2024 00:37' format
    DateTime dateTimeA = DateFormat('dd/MM/yyyy HH:mm').parse(dateTimeStrA);
    DateTime dateTimeB = DateFormat('dd/MM/yyyy HH:mm').parse(dateTimeStrB);
    return dateTimeB.compareTo(dateTimeA);
  }

  @override
  void initState() {
    super.initState();
    String id = getUserUID();
    getInfoNotification(id);
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
          'Notification',
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
              child: notifications.isEmpty
                  ? const Center(
                      child: Text(
                        'No notification',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return InkWell(
                                onTap: () {
                                  if (notification['KeyNotification'] ==
                                      'Order') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailConfirm(
                                            orderId: notification['ID_Order']),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 233, 249, 255),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 203, 202, 202)),
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
                                            const SizedBox(height: 5.0),
                                            Text(
                                              notification['Message'] ?? 'Null',
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Text(
                                              notification['Date_time'] ??
                                                  'N/A',
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
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
