//packages
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Own classes
import 'main.dart';
import 'shoppList.dart';

class Recepies extends StatefulWidget {
  @override
  State<Recepies> createState() => _RecepiesState();
}

class _RecepiesState extends State<Recepies> {
  void edit(Map<String, dynamic> items) {
    context.push('/editRec', extra: items);
  }

  void remove(Map<String, dynamic> items) {
    //context.push('/edit', extra: items);
    db
        .collection('lists')
        .doc(user?.uid)
        .collection('recepies')
        .doc(items['name'])
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    var recepies = context.watch<ShoppList>().getRecepieWidget(edit, remove);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Recepies"),
      ),
      body: ListView.separated(
          padding: EdgeInsets.all(8.0),
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          //shrinkWrap: true,
          itemCount: recepies.length,
          itemBuilder: (BuildContext context, int index) {
            return recepies[index];
          }),
      //GridView(
      //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 1,
      //       mainAxisSpacing: 8.0,
      //       crossAxisSpacing: 8.0,
      //     ),
      //     padding: const EdgeInsets.all(8.0),
      //     children: context.watch<ShoppList>().getRecepieWidget(edit, remove)),
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
                          Map<String, dynamic> newList = {
                            'name': controller.text,
                            'items': []
                          };
                          db
                              .collection('lists')
                              .doc(user?.uid)
                              .collection('recepies')
                              .doc(controller.text)
                              .set({
                            'name': controller.text,
                            'list': [],
                            'ingridients': []
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



// class ShoppList extends ChangeNotifier {
//   List<Map<String, dynamic>> _items = [];
//   String test = "";

//   ShoppList(id) {
//     print(id);
//     final listRef = db.collection("lists").doc(id);
//     listRef.snapshots().listen(
//       (event) {
//         test = event.data()?['test'];
//         _items = event.data()?['shopps'];
//         print("oooooooooooooo");
//         notifyListeners();
//       },
//       onError: (error) => print("listen failed: $error"),
//     );
//   }
// }
