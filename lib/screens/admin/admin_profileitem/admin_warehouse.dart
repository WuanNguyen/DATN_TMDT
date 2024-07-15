import 'package:doan_tmdt/screens/admin/admin_profileitem/ware_house/inventory.dart';
import 'package:doan_tmdt/screens/admin/admin_profileitem/ware_house/inventory_in.dart';
import 'package:doan_tmdt/screens/admin/admin_profileitem/ware_house/inventory_out.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdminWarehouse extends StatefulWidget {
  const AdminWarehouse({super.key});

  @override
  State<AdminWarehouse> createState() => _AdminWarehouseState();
}

class _AdminWarehouseState extends State<AdminWarehouse> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Ware house',
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
                Tab(text: 'Inventory'),
                Tab(text: 'Input'),
                Tab(text: 'Output'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [Inventory(), InventoryIn(), InventoryOut()],
          ),
        ));
  }
}
