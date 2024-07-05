import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddDiscount extends StatefulWidget {
  const AddDiscount({super.key});

  @override
  State<AddDiscount> createState() => _AddDiscountState();
}

class _AddDiscountState extends State<AddDiscount> {
  final DatabaseReference Discount_dbRef =
      FirebaseDatabase.instance.reference().child('Discounts');
  List<Discount> discount = [];

  @override
  void initState() {
    super.initState();
    Discount_dbRef.onValue.listen((event) {
      if (mounted) {
        setState(() {
          discount = event.snapshot.children
              .map((snapshot) {
                return Discount.fromSnapshot(snapshot);
              })
              .where((element) => element.Price > 0 && element.Status == false)
              .toList();
        });
      }
    });
  }

  void _updateStatus(Discount item) {
    Discount_dbRef.child(item.id).update({'Status': 1}).then((_) {
      print("Successfully updated status");
    }).catchError((error) {
      print("Failed to update status: $error");
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
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: discount.length,
              itemBuilder: (context, index) {
                final item = discount[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 233, 249, 255),
                    border: Border.all(
                        color: const Color.fromARGB(255, 203, 202, 202)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                    text: item.Price.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              item.Description,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          NotiDialog.show(context, 'Notification',
                              'Do you want to delete this discount?', () {
                            _updateStatus(item);
                          }, () {});
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.black),
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
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  addDiscount.add(
                    context,
                    0,
                    0,
                    '',
                    0,
                  );
                },
                child: const Text(
                  'Add discount',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}