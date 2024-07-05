import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hashedPassword = sha256.convert(bytes).toString();
    return hashedPassword;
  }

  void signUp(
    String email,
    String password,
    String username,
    String phone,
    String address,
    String role,
    String image_url,
    int status,
    Function onSuccess,
    Function(String) errSignup,
  ) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
// mã hóa
      String hashedPassword = hashPassword(password);

      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        String uid = user.uid;
        await _createUser(uid, email, hashedPassword, username, phone, address,
            role, image_url, status, onSuccess, errSignup);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errSignup('Email is already in use. Please use another email.');
      } else if (e.code == 'invalid-email') {
        errSignup('Invalid email. Please try again.');
      } else if (e.code == 'operation-not-allowed') {
        errSignup('Marginal error.');
      } else if (e.code == 'weak-password') {
        errSignup(
            'Password is not secure enough. Please use another password.');
      } else {
        errSignup('An error has occurred. Please try again later.');
      }
    } catch (e) {
      // Xử lý các lỗi khác không phải từ FirebaseAuthException
      print('Error during sign-up: $e');
      errSignup('An error has occurred. Please try again later.');
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
    String address,
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
      "Address": address,
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
      onError('Registration failed. Please try again.');
    }
  }
}
