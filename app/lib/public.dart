//packages
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Own classes
import 'main.dart';
import 'shoppList.dart';

class Public extends StatefulWidget {
  @override
  State<Public> createState() => _PublicState();
}

class _PublicState extends State<Public> {
  void view(Map<String, dynamic> items) {
    context.push('/view', extra: items);
  }

  @override
  Widget build(BuildContext context) {
    var recepies = context.watch<ShoppList>().getPublicWidget(view);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Public"),
      ),
      body: Column(
        children: [
          Text('data'), //TODO replace with searchbar
          ListView.separated(
              padding: EdgeInsets.all(8.0),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
              shrinkWrap: true,
              itemCount: recepies.length,
              itemBuilder: (BuildContext context, int index) {
                return recepies[index];
              }),
        ],
      ),
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
