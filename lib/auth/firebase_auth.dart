// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';

// class Fireauth {
//   FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   void registerUser(String email, String password, Function onSuccess,
//       Function(String) onError) async {
//     try {
//       // Đăng ký người dùng mới trong Firebase Authentication
//       _firebaseAuth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       User? user = _firebaseAuth.currentUser;

//       // Truy cập vào Firebase Database để lấy giá trị maxUID
//       final DatabaseReference _databaseReference =
//           FirebaseDatabase.instance.reference();
//       DataSnapshot snapshot = await _databaseReference.child('maxUID').get();
//       int currentUID = snapshot.exists ? snapshot.value as int : 0;
//       int newUID = currentUID + 1;

//       // Tạo người dùng mới trong Firebase Database
//       await _createUser(newUID.toString(), email, password, onSuccess, onError);
//     } on FirebaseAuthException catch (e) {
//       // Xử lý các lỗi từ Firebase Authentication
//       if (e.code == 'email-already-in-use') {
//         onError('Email đã được sử dụng. Vui lòng sử dụng email khác.');
//       } else if (e.code == 'invalid-email') {
//         onError('Email không hợp lệ. Vui lòng thử lại.');
//       } else if (e.code == 'operation-not-allowed') {
//         onError('Lỗi ngoài lề.');
//       } else if (e.code == 'weak-password') {
//         onError('Mật khẩu không đủ an toàn. Vui lòng sử dụng mật khẩu khác.');
//       } else {
//         onError('Đã có lỗi xảy ra. Vui lòng thử lại sau.');
//       }
//     } catch (e) {
//       // Xử lý các lỗi khác không phải từ Firebase Authentication
//       print('Error during sign-up: $e');
//       onError('Đã có lỗi xảy ra. Vui lòng thử lại sau.');
//     }
//   }

//   Future<void> _createUser(String userId, String email, String password,
//       Function onSuccess, Function(String) onError) async {
//     var userdata = {
//       'Username': 'Your_name',
//       'email': email,
//       'password': password,
//       'phone': 'phone',
//       'Image_Url': '',
//       'role': 'user',
//       'Status': '0',
//       'uid': userId,
//     };
//     var ref = FirebaseDatabase.instance.reference().child('Users');
//     try {
//       await ref.child(userId).set(userdata);
//       onSuccess();
//     } catch (e) {
//       print('Error during user creation: $e');
//       onError('Đăng ký thất bại. Vui lòng thử lại.');
//     }
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';

// class Register {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseDatabase _database = FirebaseDatabase.instance;

//   Future<void> registerUser(String email, String password) async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       User? user = userCredential.user;

//       if (user != null) {
//         // Lấy UID tuần tự mới nhất
//         DatabaseReference usersRef = _database.reference().child('Users');
//         DatabaseEvent event =
//             await usersRef.orderByChild('uid').limitToLast(1).once();
//         Map? lastUser = event.snapshot.value as Map?;

//         int newUID = 1; // UID mặc định nếu chưa có người dùng nào

//         if (lastUser != null) {
//           newUID = (lastUser.values.first['uid'] ?? 0) + 1;
//         }

//         // Lưu thông tin người dùng với UID mới
//         await usersRef.child(user.uid).set({
//           'uid': newUID,
//           'email': user.email,
//         });
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signUp(
    String email,
    String password,
    String username,
    String phone,
    String role,
    String image_url,
    int status,
    Function onSuccess,
    Function(String) errSignup,
  ) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        String uid = user.uid;
        await _createUser(uid, email, password, username, phone, role,
            image_url, status, onSuccess, errSignup);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errSignup('Email đã được sử dụng. Vui lòng sử dụng email khác.');
      } else if (e.code == 'invalid-email') {
        errSignup('Email không hợp lệ. Vui lòng thử lại.');
      } else if (e.code == 'operation-not-allowed') {
        errSignup('Lỗi ngoài lề.');
      } else if (e.code == 'weak-password') {
        errSignup('Mật khẩu không đủ an toàn. Vui lòng sử dụng mật khẩu khác.');
      } else {
        errSignup('Đã có lỗi xảy ra. Vui lòng thử lại sau.');
      }
    } catch (e) {
      // Xử lý các lỗi khác không phải từ FirebaseAuthException
      print('Error during sign-up: $e');
      errSignup('Đã có lỗi xảy ra. Vui lòng thử lại sau.');
    }
  }

  //---
  void signIn(String email, String password, Function onSuccess,
      Function(String) ErrSignIn) async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {
        //thanh cong
        onSuccess();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code != null) {
        ErrSignIn('Login failed. Please try again later');
      }
    } catch (e) {
      // Xử lý các lỗi khác không phải từ FirebaseAuthException
      print('Error during sign-up: $e');
      ErrSignIn('Login failed. Please try again later');
    }
  }
  //---

  Future<void> _createUser(
    String userId,
    String email,
    String password,
    String username,
    String phone,
    String role,
    String image_url,
    int status,
    Function onSuccess,
    Function(String) onError,
  ) async {
    var user = {
      "Email": email,
      "Password": password,
      "ID_User": userId,
      "Username": username,
      "Phone": phone,
      "Role": role,
      "Image_Url": image_url,
      "Status": status,
    };
    var ref = FirebaseDatabase.instance.reference().child('Users');
    try {
      await ref.child(userId).set(user);
      onSuccess();
    } catch (e) {
      print('Error during user creation: $e');
      onError('Đăng ký thất bại. Vui lòng thử lại.');
    }
  }
}
