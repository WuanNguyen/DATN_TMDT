import 'package:doan_tmdt/screens/profile_items/status_order/confirm.dart';
import 'package:doan_tmdt/screens/profile_items/status_order/delivery.dart';
import 'package:doan_tmdt/screens/profile_items/status_order/received.dart';
import 'package:flutter/material.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Order history',
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
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Confirm'),
                Tab(text: 'Delivery'),
                Tab(text: 'received'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [Confirm(), Delivery(), Received()],
          ),
        ));
  }
}
