import 'package:doan_tmdt/screens/admin/admin_profileitem/users/account_user.dart';
import 'package:doan_tmdt/screens/admin/admin_profileitem/users/banned_account.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdminListUser extends StatefulWidget {
  const AdminListUser({super.key});

  @override
  State<AdminListUser> createState() => _AdminListUserState();
}

class _AdminListUserState extends State<AdminListUser> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
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
                Tab(text: 'Account user'),
                Tab(text: 'Banned account'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [AccountUser(), BannedAccount()],
          ),
        ));
  }
}
