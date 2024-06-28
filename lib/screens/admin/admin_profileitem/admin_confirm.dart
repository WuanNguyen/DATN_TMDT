import 'package:flutter/material.dart';

class AdminConfirm extends StatefulWidget {
  const AdminConfirm({super.key});

  @override
  State<AdminConfirm> createState() => _AdminConfirmState();
}

class _AdminConfirmState extends State<AdminConfirm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              child: Column(),
            ),
          )
        ],
      ),
    );
  }
}
