import 'package:doan_tmdt/screens/admin/status_add/add_discount.dart';
import 'package:doan_tmdt/screens/admin/status_add/add_distributor.dart';
import 'package:doan_tmdt/screens/admin/status_add/add_product.dart';
import 'package:flutter/material.dart';

class AdminAdd extends StatefulWidget {
  const AdminAdd({super.key});

  @override
  State<AdminAdd> createState() => _AdminAddState();
}

class _AdminAddState extends State<AdminAdd> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: const Color.fromRGBO(201, 241, 248, 1),
              child: const TabBar(
                tabs: [
                  Tab(text: 'Product'),
                  Tab(text: 'Distributor'),
                  Tab(text: 'Discount'),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [AddProduct(), AddDistributor(), AddDiscount()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
