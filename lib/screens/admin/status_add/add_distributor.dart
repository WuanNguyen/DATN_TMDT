import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddDistributor extends StatefulWidget {
  const AddDistributor({super.key});

  @override
  State<AddDistributor> createState() => _AddDistributorState();
}

class _AddDistributorState extends State<AddDistributor> {
  TextEditingController nameText = TextEditingController();
  TextEditingController emailText = TextEditingController();
  TextEditingController addressText = TextEditingController();
  TextEditingController phoneText = TextEditingController();

  final DatabaseReference Distributors_dbRef =
      FirebaseDatabase.instance.ref().child('Distributors');
  List<Distributors> distributors = [];

  @override
  void initState() {
    super.initState();
    Distributors_dbRef.onValue.listen((event) {
      if (mounted) {
        setState(() {
          distributors = event.snapshot.children
              .map((snapshot) {
                return Distributors.fromSnapshot(snapshot);
              })
              .where(
                (element) => element.Status == 0,
              )
              .toList();
        });
      }
    });
  }

  void _updateStatus(Distributors item, int newStatus) {
    Distributors_dbRef.child(item.ID_Distributor).update({
      'Status': newStatus,
    }).then((_) {
      print("Successfully updated status");
    }).catchError((error) {
      print("Failed to update status: $error");
    });
  }

  void _updateDistributor(Distributors item, String newDistributor_Name,
      String newEmail, String newAddress, String newPhone) {
    Distributors_dbRef.child(item.ID_Distributor.toString()).update({
      'Distributor_Name': newDistributor_Name,
      'Email': newEmail,
      'Address': newAddress,
      'Phone': newPhone
    }).then((_) {
      print("Successfully updated distributor");
    }).catchError((error) {
      print("Failed to update distributor: $error");
    });
  }

  void _clearTextControllers() {
    nameText.clear();
    emailText.clear();
    addressText.clear();
    phoneText.clear();
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
              itemCount: distributors.length,
              itemBuilder: (context, index) {
                final item = distributors[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 233, 249, 255),
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
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Name: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: distributors[index].Distributor_Name!,
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
                                    text: 'Email: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: distributors[index].Email!,
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
                                    text: 'Address: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: distributors[index].Address!,
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
                                    text: 'Phone: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: distributors[index].Phone!,
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
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              NotiDialog.show(context, 'Notification',
                                  'Do you want to delete Distributor', () {
                                _updateStatus(item, 1);
                              }, () {});
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              addDistributor.updateDis(context, nameText,
                                  emailText, addressText, phoneText, () {
                                if (nameText.text.isEmpty ||
                                    emailText.text.isEmpty ||
                                    addressText.text.isEmpty ||
                                    phoneText.text.isEmpty) {
                                  _clearTextControllers();
                                  MsgDialog.MSG(context, 'Notification',
                                      'Please enter complete information');
                                } else {
                                  _updateDistributor(
                                    item,
                                    nameText.text,
                                    emailText.text,
                                    addressText.text,
                                    phoneText.text,
                                  );
                                }
                              });
                            },
                            child: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.black),
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  addDistributor.add(context, '', '', '', '');
                },
                child: Text(
                  'Add Distributor',
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
