import 'package:app/shoppList.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditList extends StatefulWidget {
  Map<String, dynamic> items;
  EditList({required this.items});

  @override
  State<EditList> createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  @override
  Widget build(BuildContext context) {
    ShoppList model = Provider.of<ShoppList>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.items['name']),
      ),
      body: ListView(
          padding: const EdgeInsets.all(8.0),
          children:
              context.watch<ShoppList>().getItemWidget(widget.items['list'])),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          var controller = TextEditingController();
          showDialog(
              context: context,
              builder: (BuildContext) {
                return AlertDialog(
                  title: const Text('data'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        child: TextFormField(
                      controller: controller,
                    )),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          // db.collection('lists').doc(user?.uid).update({
                          //   'shopps': FieldValue.arrayRemove([widget.items])
                          // });
                          Map<String, dynamic> newList = {
                            'name': controller.text,
                            'price': 5
                          };
                          // widget.items['items'].add(newList);
                          // db.collection('lists').doc(user?.uid).update({
                          //   'shopps': FieldValue.arrayUnion([widget.items])
                          // });
                          db
                              .collection('lists')
                              .doc(user?.uid)
                              .collection('shopps')
                              .doc(widget.items['name'])
                              .update({
                            'list': FieldValue.arrayUnion([newList])
                          }); //TODO fanskapet uppdaterar inte
                          ShoppList.updateItemWidget(widget.items['list']);
                          context.pop();
                        },
                        child: const Text('create'))
                  ],
                );
              });
        }),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              context.go('/');
            case 1:
              context.go('/recepies');
            case 2:
              context.go('/account');
          }
        },
      ),
    );
  }

  // List<Widget> getItemWidget() {
  //   List<Widget> res = [];
  //   for (Map<String, dynamic> e in widget.items['items']) {
  //     res.add(Container(
  //         color: Colors.blue,
  //         child: Column(children: [
  //           Text(e['name']),
  //           Text(e['price'].toString()),
  //           ElevatedButton(
  //               onPressed: () {
  //                 //edit(e);
  //               },
  //               child: const Text('Edit list')),
  //         ])));
  //   }
  //   return res;
  // }
}
