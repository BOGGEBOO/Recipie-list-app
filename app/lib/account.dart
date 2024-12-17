import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'shoppList.dart';

class Account extends StatefulWidget {
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Account"),
      ),
      body: Center(
          child: Column(
        children: [
          Text(
            context.watch<ShoppList>().getName()!,
            style: TextStyle(height: 5, fontSize: 40),
          ),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Lists",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Recepies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Public',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              context.go('/list');
            case 1:
              context.go('/recepies');
            case 2:
              context.go('/account');
            case 3:
              context.go('/public');
          }
        },
      ),
    );
  }
}
