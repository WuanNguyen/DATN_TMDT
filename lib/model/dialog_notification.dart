import 'package:flutter/material.dart';

class MsgDialog {
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
