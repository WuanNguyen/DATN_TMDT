import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/screens/admin/status_add/add_product.dart';
import 'package:doan_tmdt/screens/login/firstapp_screen.dart';
import 'package:doan_tmdt/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MsgDialog {
  static void MSG(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.0, 0.7, 1],
                  transform: GradientRotation(50),
                  colors: [
                    Color.fromRGBO(54, 171, 237, 0.80),
                    Color.fromRGBO(149, 172, 205, 0.75),
                    Color.fromRGBO(244, 173, 173, 0.1),
                  ])),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                msg,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(MsgDialog);
                    },
                    child: const Text(
                      'ok',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //---------------------------------
  //notification -> loginscreen
  static void notilogin(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.0, 0.7, 1],
                  transform: GradientRotation(50),
                  colors: [
                    Color.fromRGBO(54, 171, 237, 0.80),
                    Color.fromRGBO(149, 172, 205, 0.75),
                    Color.fromRGBO(244, 173, 173, 0.1),
                  ])),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                msg,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(MsgDialog);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text(
                      'ok',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //------------------
  static void ShowDialog(BuildContext context, String title, String msg) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                title,
                style: TextStyle(color: Color.fromARGB(255, 240, 154, 147)),
              ),
              content: Text(
                msg,
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pop(MsgDialog);
                  },
                  child: Text(
                    'Ok',
                    style:
                        TextStyle(color: const Color.fromARGB(255, 51, 0, 0)),
                  ),
                )
              ],
              backgroundColor: Color.fromRGBO(46, 91, 69, 1),
            ));
  }

  //-------------
  static void MsgDeleteAccount(BuildContext context, String title, String msg) {
    int status = 0;
    Future<void> updateUserInfo() async {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DatabaseReference userRef = FirebaseDatabase.instance
            .reference()
            .child('Users')
            .child(currentUser.uid);
        await userRef.update({
          'Status': status,
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.0, 0.7, 1],
                  transform: GradientRotation(50),
                  colors: [
                    Color.fromRGBO(54, 171, 237, 0.80),
                    Color.fromRGBO(149, 172, 205, 0.75),
                    Color.fromRGBO(244, 173, 173, 0.1),
                  ])),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                msg,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(MsgDialog);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(MsgDialog);
                      status = 1;
                      updateUserInfo();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FirstappScreen()),
                      );
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

//-------------------------------------------------------Đã fix
class addDistributor {
  static void add(BuildContext context, String name, String email,
      String address, String phone) {
    TextEditingController nameText = TextEditingController(text: name);
    TextEditingController emailText = TextEditingController(text: email);
    TextEditingController addressText = TextEditingController(text: address);
    TextEditingController phoneText = TextEditingController(text: phone);

    Future<void> _updateDistributor() async {
      //------------------------------------------------
      //update
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();
      //
      DataSnapshot snapshot =
          await _databaseReference.child('Max').child('MaxDistributor').get();

      int currentUID = snapshot.exists ? snapshot.value as int : 0;
      int newUID = currentUID + 1;
      String UIDC = "Distributor$newUID";
      //
      await _databaseReference.child('Distributors').child(UIDC).set({
        'ID_Distributor': UIDC,
        'Distributor_Name': nameText.text,
        'Address': addressText.text,
        'Email': emailText.text,
        'Phone': phoneText.text,
        'Status': 0
      });
      // Cập nhật UID lớn nhất
      await _databaseReference.child('Max').child('MaxDistributor').set(newUID);
      //

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Added Distributor successfully',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(255, 125, 125, 125),
      ));
    }

    Future<bool> isEmailExists(String email) async {
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();
      DatabaseEvent event = await _databaseReference
          .child('Distributors')
          .orderByChild('Email')
          .equalTo(email)
          .once();

      return event.snapshot.value != null;
    }

    Future<bool> isPhoneExists(String phone) async {
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();
      DatabaseEvent event = await _databaseReference
          .child('Distributors')
          .orderByChild('Phone')
          .equalTo(phone)
          .once();

      return event.snapshot.value != null;
    }

    //kiểm tra sdt
    bool isValidPhoneNumber(String input) {
      final RegExp regex = RegExp(r'^0\d{9}$');
      return regex.hasMatch(input);
    }

    bool isValidGmail(String input) {
      // Biểu thức chính quy kiểm tra xem chuỗi là địa chỉ email Gmail hợp lệ hay không
      final RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
      return regex.hasMatch(input);
    }

    //------------------------------------------------
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.0, 0.7, 1],
                  transform: GradientRotation(50),
                  colors: [
                    Color.fromRGBO(54, 171, 237, 0.80),
                    Color.fromRGBO(149, 172, 205, 0.75),
                    Color.fromRGBO(244, 173, 173, 0.1),
                  ])),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameText,
                      obscureText: false,
                      decoration: InputDecoration(
                          label: Text("Distributor name",
                              style: TextStyle(fontWeight: FontWeight.w500))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: emailText,
                      obscureText: false,
                      decoration: InputDecoration(
                          label: Text("Email",
                              style: TextStyle(fontWeight: FontWeight.w500))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: addressText,
                      obscureText: false,
                      decoration: InputDecoration(
                          label: Text("Address",
                              style: TextStyle(fontWeight: FontWeight.w500))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: phoneText,
                      obscureText: false,
                      decoration: InputDecoration(
                          label: Text("Phone",
                              style: TextStyle(fontWeight: FontWeight.w500))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!isValidGmail(emailText.text)) {
                          MsgDialog.MSG(
                              context, 'Notification', 'Email invalidate');
                        } else if (!isValidPhoneNumber(phoneText.text)) {
                          MsgDialog.MSG(
                              context, 'Notification', 'Phone invalidate');
                        } else if (nameText.text.isEmpty ||
                            emailText.text.isEmpty ||
                            addressText.text.isEmpty ||
                            phoneText.text.isEmpty) {
                          MsgDialog.MSG(context, 'Notification',
                              'Information cannot be left blank');
                        } else {
                          bool emailExists =
                              await isEmailExists(emailText.text);
                          bool phoneExists =
                              await isPhoneExists(phoneText.text);
                          if (emailExists) {
                            MsgDialog.MSG(context, 'Notification',
                                'Email already exists');
                          } else if (phoneExists) {
                            MsgDialog.MSG(context, 'Notification',
                                'Phone already exists');
                          } else {
                            await _updateDistributor();
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //------------------------
  static void updateDis(
      BuildContext context,
      TextEditingController nameText,
      TextEditingController emailText,
      TextEditingController addressText,
      TextEditingController phoneText,
      VoidCallback onOkPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.7, 1],
              transform: GradientRotation(50),
              colors: [
                Color.fromRGBO(54, 171, 237, 0.80),
                Color.fromRGBO(149, 172, 205, 0.75),
                Color.fromRGBO(244, 173, 173, 0.1),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameText,
                      obscureText: false,
                      decoration: InputDecoration(
                          labelText: "Distributor name",
                          labelStyle: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: emailText,
                      obscureText: false,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: addressText,
                      obscureText: false,
                      decoration: InputDecoration(
                          labelText: "Address",
                          labelStyle: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: phoneText,
                      obscureText: false,
                      decoration: InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onOkPressed != null) {
                          onOkPressed();
                        }
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

//-------------------------------------------------------------
class addDiscount {
  static void add(
    BuildContext context,
    // String title,
    //String msg,
    int price,
    int required,
    String desc,
    int uses,
  ) {
    TextEditingController priceText =
        TextEditingController(text: price.toString());
    TextEditingController requiredText =
        TextEditingController(text: required.toString());
    TextEditingController descText = TextEditingController(text: desc);
    TextEditingController usesText =
        TextEditingController(text: uses.toString());
    Future<void> UpdateDiscount() async {
      //------------------------------------------------
      //update
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();
      //
      DataSnapshot snapshot =
          await _databaseReference.child('Max').child('MaxDiscount').get();

      int currentUID = snapshot.exists ? snapshot.value as int : 0;
      int newUID = currentUID + 1;
      String UIDC = 'Discount$newUID';
      //
      await _databaseReference.child('Discounts').child(UIDC).set({
        'ID_Discount': UIDC,
        'Price': priceText.text,
        'Description': descText.text,
        'Required': requiredText.text,
        'Uses': int.parse(usesText.text),
        'Status': 0
      });
      // Cập nhật UID lớn nhất
      await _databaseReference.child('Max').child('MaxDiscount').set(newUID);

      //

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'added discount successfully',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(255, 125, 125, 125),
      ));
    }

    //------------------------------------------------
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.0, 0.7, 1],
                  transform: GradientRotation(50),
                  colors: [
                    Color.fromRGBO(54, 171, 237, 0.80),
                    Color.fromRGBO(149, 172, 205, 0.75),
                    Color.fromRGBO(244, 173, 173, 0.1),
                  ])),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: descText,
                      maxLines: 4,
                      minLines: 4,
                      obscureText: false,
                      decoration: InputDecoration(
                          label: Text("Description",
                              style: TextStyle(fontWeight: FontWeight.w500))),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: priceText,
                          obscureText: false,
                          decoration: InputDecoration(
                              label: Text("Price",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: requiredText,
                          obscureText: false,
                          decoration: InputDecoration(
                              label: Text("Required",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: usesText,
                          obscureText: false,
                          decoration: InputDecoration(
                              label: Text("Uses",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (priceText.text == '0' ||
                            requiredText.text == '0' ||
                            usesText.text == '0') {
                          MsgDialog.MSG(context, 'Notification',
                              'Information cannot be left blank');
                        } else {
                          UpdateDiscount();
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// add_product admin---------------------------------------------------------------------
class admin_addproduct {
  static void add(
    BuildContext context,
    int stt,
    String msg,
    //String Sizetext,
    String sizeTemp,
    int discount,
    // int id_product,
    int importPrice,
    int sellPrice,
    int stock,
    //int status,
  ) {
    TextEditingController discountText =
        TextEditingController(text: discount.toString());
    TextEditingController importPriceText =
        TextEditingController(text: importPrice.toString());
    TextEditingController sellpriceText =
        TextEditingController(text: sellPrice.toString());
    TextEditingController stockText =
        TextEditingController(text: stock.toString());

    //----------------------------------------------------
    Future<void> updateProSize() async {
      //------------------------------------------------
      //update
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();

      await _databaseReference.child('Temp').child(sizeTemp).set({
        'stt': stt, // trạng thái để cập nhật bên product là đã nhấn chưa
        'ImportPrice': int.parse(importPriceText.text),
        'SellPrice': int.parse(sellpriceText.text),
        'Stock': int.parse(stockText.text),
        'Discount': int.parse(discountText.text)
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.0, 0.7, 1],
                  transform: GradientRotation(50),
                  colors: [
                    Color.fromRGBO(54, 171, 237, 0.80),
                    Color.fromRGBO(149, 172, 205, 0.75),
                    Color.fromRGBO(244, 173, 173, 0.1),
                  ])),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Size ' + msg,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: importPriceText,
                          obscureText: false,
                          decoration: InputDecoration(
                              label: Text("ImportPrice",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: sellpriceText,
                          obscureText: false,
                          decoration: InputDecoration(
                              label: Text("Sell price",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: stockText,
                          obscureText: false,
                          decoration: InputDecoration(
                              label: Text("Stock",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: discountText,
                          obscureText: false,
                          decoration: InputDecoration(
                              label: Text("Discount",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (stockText.text == '0' ||
                            importPriceText.text == '0' ||
                            sellpriceText.text == '0') {
                          Navigator.of(context).pop();
                          MsgDialog.MSG(context, 'Notification',
                              'Not filled in enough information');
                          importPriceText.clear();
                          sellpriceText.clear();
                          discountText.clear();
                          stockText.clear();
                        } else {
                          updateProSize();
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static void sizes(
    BuildContext context,
    // int sizeP,
    // int -----------------------------------
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.0, 0.7, 1],
                  transform: GradientRotation(50),
                  colors: [
                    Color.fromRGBO(54, 171, 237, 0.80),
                    Color.fromRGBO(149, 172, 205, 0.75),
                    Color.fromRGBO(244, 173, 173, 0.1),
                  ])),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String size = "S";
                      Navigator.of(context).pop();
                      admin_addproduct.add(context, 0, size, size, 0, 0, 0, 0);
                    },
                    child: const Text(
                      'S',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String size = "M";
                      Navigator.of(context).pop();
                      admin_addproduct.add(context, 0, size, size, 0, 0, 0, 0);
                    },
                    child: const Text(
                      'M',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String size = "L";
                      Navigator.of(context).pop();
                      admin_addproduct.add(context, 0, size, size, 0, 0, 0, 0);
                    },
                    child: const Text(
                      'L',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// thông báo mới khi edit , thêm
class NotiDialog {
  static void showok(BuildContext context, String title, String msg,
      VoidCallback onOkPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(27),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.7, 1],
              transform: GradientRotation(50),
              colors: [
                Color.fromRGBO(54, 171, 237, 0.80),
                Color.fromRGBO(149, 172, 205, 0.75),
                Color.fromRGBO(244, 173, 173, 0.1),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                msg,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onOkPressed != null) {
                        onOkPressed();
                      }
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context, String title, String msg,
      VoidCallback onOkPressed, VoidCallback onCancelPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(27),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.7, 1],
              transform: GradientRotation(50),
              colors: [
                Color.fromRGBO(54, 171, 237, 0.80),
                Color.fromRGBO(149, 172, 205, 0.75),
                Color.fromRGBO(244, 173, 173, 0.1),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                msg,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onCancelPressed != null) {
                        onCancelPressed();
                      }
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onOkPressed != null) {
                        onOkPressed();
                      }
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Forgotpassword {
  static void show(
      BuildContext context,
      String title,
      TextEditingController emailText,
      VoidCallback onOkPressed,
      VoidCallback onCancelPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(27),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.7, 1],
              transform: GradientRotation(50),
              colors: [
                Color.fromRGBO(54, 171, 237, 0.80),
                Color.fromRGBO(149, 172, 205, 0.75),
                Color.fromRGBO(244, 173, 173, 0.1),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: emailText,
                      obscureText: false,
                      decoration: InputDecoration(
                          label: Text("Email",
                              style: TextStyle(fontWeight: FontWeight.w500))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onCancelPressed != null) {
                        onCancelPressed();
                      }
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onOkPressed != null) {
                        onOkPressed();
                      }
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// s
class dialogBottom {
  static void ShowBottom(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      backgroundColor: Color.fromARGB(255, 125, 125, 125),
    ));
  }
}
//-------------admin show product detail

class admin_showPro {
  static Future<ProductSizeDetail?> showEditDialog(
      BuildContext context, ProductSizeDetail currentDetail) async {
    TextEditingController sellPriceController =
        TextEditingController(text: currentDetail.SellPrice.toString());
    TextEditingController discountController =
        TextEditingController(text: currentDetail.Discount.toString());
    TextEditingController stockController =
        TextEditingController(text: currentDetail.Stock.toString());
    TextEditingController importPriceController =
        TextEditingController(text: currentDetail.ImportPrice.toString());

    return await showDialog<ProductSizeDetail>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Size'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: sellPriceController,
                decoration: InputDecoration(labelText: 'Sell Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: discountController,
                decoration: InputDecoration(labelText: 'Discount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: importPriceController,
                decoration: InputDecoration(labelText: 'Import Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(ProductSizeDetail(
                  ID_Product: currentDetail.ID_Product,
                  SellPrice: int.parse(sellPriceController.text),
                  Discount: int.parse(discountController.text),
                  Stock: int.parse(stockController.text),
                  ImportPrice: int.parse(importPriceController.text),
                  Status: currentDetail.Status,
                ));
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
