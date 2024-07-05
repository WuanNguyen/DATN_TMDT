import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Textdata extends StatefulWidget {
  const Textdata({Key? key}) : super(key: key);

  @override
  State<Textdata> createState() => _TextdataState();
}

class _TextdataState extends State<Textdata> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          // Đọc UID hiện tại lớn nhất
          DataSnapshot snapshot =
              await _databaseReference.child('maxUID').get();

          int currentUID = snapshot.exists ? snapshot.value as int : 0;
          int newUID = currentUID + 1;

          // Lưu người dùng mới với UID mới
          await _databaseReference.child('text').child(newUID.toString()).set({
            'Username': 'YourName',
            'Password': 'Password',
            'Email': 'your_email',
            'phone': 'your_address',
            'Role': 'user',
            'Image_Url':
                'https://firebasestorage.googleapis.com/v0/b/tmdt-bangiay.appspot.com/o/images%2Favatarface.jpg?alt=media&token=7da6a34c-02df-4551-b67e-66058d33a72f',
            'status': '0'
          });

          // Cập nhật UID lớn nhất
          await _databaseReference.child('maxUID').set(newUID);

          print('UID người dùng được tạo: $newUID');
        },
        child: Icon(Icons.abc),
      ),
    );
  }
}
