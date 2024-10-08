//packages
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

//Own classes
import 'main.dart';
import 'shoppList.dart';

class Recepies extends StatefulWidget {
  @override
  State<Recepies> createState() => _RecepiesState();
}

class _RecepiesState extends State<Recepies> {
  void edit(Map<String, dynamic> items) {
    context.go('/edit', extra: items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("widget.title"),
      ),
      body: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          padding: const EdgeInsets.all(8.0),
          children: context.watch<ShoppList>().getShoppWidget(edit)),
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
