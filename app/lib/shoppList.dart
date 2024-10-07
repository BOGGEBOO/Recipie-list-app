//packages
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//Own classes
import 'main.dart';

class ShoppList extends ChangeNotifier {
  String? id;
  String name = "";
  List shopps = [];

  ShoppList.instance(id) {
    getFromFirestore(id);
  }

  getFromFirestore(id) async {
    final listref = db.collection("lists").doc(id);
    listref.snapshots().listen((event) {
      id = id;
      name = event.data()?['name'];
      shopps = event.data()?['shopps'];
    });
    notifyListeners();
  }

  List<Widget> getShoppWidget(edit) {
    List<Widget> res = [];
    for (Map<String, dynamic> e in shopps) {
      res.add(Container(
          color: Colors.blue,
          child: Column(children: [
            Text(e['name']),
            ElevatedButton(
                onPressed: () {
                  edit(e);
                },
                child: const Text('Edit list')),
          ])));
    }
    return res;
  }
}
