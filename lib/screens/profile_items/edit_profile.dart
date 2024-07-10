import 'dart:io';
import 'dart:typed_data';

import 'package:doan_tmdt/model/bottom_navigation.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:doan_tmdt/screens/profile_items/address.dart';
import 'package:doan_tmdt/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //----------------------------
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();
  //--------------------------
  String image =
      "https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a";

  //------------------
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  //--------------------
  //kiểm tra sdt
  bool isValidPhoneNumber(String input) {
    final RegExp regex = RegExp(r'^0\d{9}$');
    return regex.hasMatch(input);
  }

  //------------------------
  Future<void> getUserInfo() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child(currentUser.uid);
      DataSnapshot snapshot = await userRef.once().then((DatabaseEvent event) {
        return event.snapshot;
      });
      if (snapshot.value != null) {
        Map userData = snapshot.value as Map;
        setState(() {
          name.text = userData['Username'] ?? '';
          address.text = userData['Address'] ?? '';
          phone.text = userData['Phone'] ?? '';
          // roleController.text = userData['Role'] ?? '';
          image = userData['Image_Url'] ?? '';
          //  statusController.text = userData['Status'].toString() ?? '0';
        });
      }
    }
  }

  //---------------------------------------------------
  Future<void> updateUserInfo() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child(currentUser.uid);
      await userRef.update({
        'Username': name.text,
        'Address': address.text,
        'Phone': phone.text,
        // 'Role': roleController.text,
        'Image_Url': image,
        // 'Status': int.parse(statusController.text),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'User info updated',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(255, 125, 125, 125),
      ));
    }
  }

  //--------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit profile',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color.fromRGBO(201, 241, 248, 1),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
                const SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          image,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 24,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            String? imageUrl =
                                await pickAndUploadImageToFirebase();
                            if (imageUrl != null) {
                              setState(() {
                                image = imageUrl;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  'Photo has been updated',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255)),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 125, 125, 125),
                              ));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: name,
                          obscureText: false,
                          decoration: InputDecoration(
                              label: Text('name',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    )),
                const SizedBox(height: 20),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: address,
                          obscureText: false,
                          decoration: InputDecoration(
                              label: Text("Address",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    )),
                const SizedBox(height: 20),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: phone,
                          obscureText: false,
                          decoration: InputDecoration(
                              label: Text("Phone",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                      ],
                    )),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          elevation: 8,
                          shadowColor: Colors.white),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      onPressed: () {
                        if (name.text.isEmpty ||
                            address.text.isEmpty ||
                            phone.text.isEmpty) {
                          MsgDialog.MSG(context, 'Warning',
                              'Please enter complete information');
                        } else if (isValidPhoneNumber(phone.text) == false) {
                          MsgDialog.MSG(
                              context, 'Warning', 'invalid phone number');
                        } else {
                          updateUserInfo();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BottomNavigation(index: 3)),
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  // upload ảnh-------------
  Future<String?> pickAndUploadImageToFirebase() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return null;

    Uint8List imageData = await File(file.path!).readAsBytes();
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDireImages = referenceRoot.child('image_users');
    Reference referenceUpLoad = referenceDireImages.child(fileName);

    try {
      await referenceUpLoad.putData(
          imageData, SettableMetadata(contentType: 'image/png'));

      // Lấy đường dẫn URL của ảnh sau khi tải lên
      String downloadUrl = await referenceUpLoad.getDownloadURL();
      print('Download URL: $downloadUrl');

      return downloadUrl;
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      // Xử lý lỗi nếu cần thiết
      return null;
    }
  }
}
