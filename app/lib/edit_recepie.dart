import 'package:app/shoppList.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRecepie extends StatefulWidget {
  Map<String, dynamic> items;
  EditRecepie({required this.items});

  @override
  State<EditRecepie> createState() => _EditListState();
}

class _EditListState extends State<EditRecepie> {
  void edit(Map<String, dynamic> item) {
    //context.push('/edit', extra: items);
    widget.items['list'].removeWhere((value) =>
        value["id"] == item["id"] &&
        value['name'] == item['name'] &&
        value['price'] == item['price']);
    db
        .collection('lists')
        .doc(user?.uid)
        .collection('recepies')
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

    List<Widget> ingridiens = context
        .watch<ShoppList>()
        .getIngridientWidget(widget.items['ingridients']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.items['name']),
      ),
      body: Column(
        //mainAxisSize: MainAxisSize.max,
        children: [
          ElevatedButton(
              onPressed: () {
                //context.push('/edit', extra: widget.items);
                db
                    .collection('lists')
                    .doc(user?.uid)
                    .collection('shopps')
                    .doc(widget.items['name'])
                    .set({
                  'name': widget.items['name'],
                  'list': widget.items['list']
                });
                // for (Map<String, dynamic> e in widget.items['list']){

                // }
              },
              child: const Text('Make shopplist')),
          Flexible(
            child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                children: context
                    .watch<ShoppList>()
                    .getItemWidget(widget.items['list'], edit)),
          ),
          ElevatedButton(
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
                                    ]),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    // db.collection('lists').doc(user?.uid).update({
                                    //   'recepies': FieldValue.arrayRemove([widget.items])
                                    //});
                                    Map<String, dynamic> newList = {
                                      'name': controller.text,
                                      'price': priceController.text,
                                      'id': widget.items['list'].length
                                    };
                                    widget.items['list'].add(newList);
                                    db
                                        .collection('lists')
                                        .doc(user?.uid)
                                        .collection('recepies')
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
              child: const Text("Add ingridient")),
          Expanded(
            child: ListView.separated(
                padding: EdgeInsets.all(8.0),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                //shrinkWrap: true,
                itemCount: ingridiens.length,
                itemBuilder: (BuildContext context, int index) {
                  return ingridiens[index];
                }),
          ),
          ElevatedButton(
              onPressed: () {
                //context.push('/edit', extra: widget.items);
                db
                    .collection('lists')
                    .doc(user?.uid)
                    .collection('recepies')
                    .doc(widget.items['name'])
                    .get()
                    .then(
                  (DocumentSnapshot doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    db.collection('public').add(data);
                  },
                );
              },
              child: const Text('Public')),
        ],
      ),
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
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextFormField(
                          controller: controller,
                        ),
                      ]),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          // db.collection('lists').doc(user?.uid).update({
                          //   'recepies': FieldValue.arrayRemove([widget.items])
                          //});
                          Map<String, dynamic> newList = {
                            'disc': controller.text,
                            'id': widget.items['ingridients'].length
                          };
                          widget.items['ingridients'].add(newList);
                          db
                              .collection('lists')
                              .doc(user?.uid)
                              .collection('recepies')
                              .doc(widget.items['name'])
                              .update({
                            'ingridients': FieldValue.arrayUnion([newList])
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
