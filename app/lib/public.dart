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

  List<Widget> recepies = [];

  @override
  Widget build(BuildContext context) {
    //var recepies = context.watch<ShoppList>().getPublicWidget(view);
    var controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Public"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.arrow_forward),
                  suffixIcon: IconButton(
                      onPressed: () {
                        recepies.clear();

                        // if (controller.text.isEmpty) {
                        //   recepies =
                        //       context.watch<ShoppList>().getPublicWidget(view);
                        // }

                        db
                            .collection('public')
                            .where("name", isEqualTo: controller.text)
                            .get()
                            .then((querySnapshot) {
                          setState(() {
                            for (var e in querySnapshot.docs) {
                              recepies.add(Container(
                                  color: Colors.blue,
                                  child: Column(children: [
                                    Text(e['name']),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              view(e.data());
                                            },
                                            child: const Text('view recepie')),
                                      ],
                                    )
                                  ])));
                            }
                          });
                        });
                      },
                      icon: Icon(Icons.search))),
            ),
          ),
          ListView.builder(
              padding: EdgeInsets.all(8.0),
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
