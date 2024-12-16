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
  void edit(Map<String, dynamic> item) {
    widget.items['list'].removeWhere((value) =>
        value["id"] == item["id"] &&
        value['name'] == item['name'] &&
        value['price'] == item['price']);
    db
        .collection('lists')
        .doc(user?.uid)
        .collection('shopps')
        .doc(widget.items['name'])
        .update({
      'list': FieldValue.arrayRemove([
        {"name": item['name'], "price": item['price'], "id": item['id']}
      ])
    });
  }

  @override
  Widget build(BuildContext context) {
    ShoppList model = Provider.of<ShoppList>(context, listen: true);

    List<Widget> items =
        context.watch<ShoppList>().getItemWidget(widget.items['list'], edit);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.items['name']),
      ),
      body: ListView.separated(
          padding: EdgeInsets.all(8.0),
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return items[index];
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          var controller = TextEditingController();
          var priceController = TextEditingController();
          showDialog(
              context: context,
              builder: (BuildContext) {
                return AlertDialog(
                  title: const Text('data'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: controller,
                        ),
                        TextFormField(
                          controller: priceController,
                        )
                      ],
                    )),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Map<String, dynamic> newList = {
                            'name': controller.text,
                            'price': priceController.text,
                            'id': items.length
                          };
                          widget.items['list'].add(newList);
                          db
                              .collection('lists')
                              .doc(user?.uid)
                              .collection('shopps')
                              .doc(widget.items['name'])
                              .update({
                            'list': FieldValue.arrayUnion([newList])
                          });
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
    );
  }
}
