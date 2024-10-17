import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';

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
        title: Text("widget.title"),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () => context.go('/list'), child: Text("Home"))),
      bottomNavigationBar: BottomNavigationBar(
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
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              context.go('/list');
            case 1:
              context.go('/recepies');
            case 2:
              context.go('/account');
          }
        },
      ),
    );
  }
}
