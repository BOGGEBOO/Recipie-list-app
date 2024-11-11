//packages
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//Own classes
import 'main.dart';

class ShoppList extends ChangeNotifier {
  String? id;
  String? name;
  List shopps = [];
  List recepies = [];

  ShoppList.instance(id) {
    getFromFirestore(id);
  }

  getFromFirestore(id) async {
    final listref = db.collection("lists").doc(id);
    listref.snapshots().listen((event) {
      id = id;
      String temp = event.data()?['name'];
      if (temp != name) {
        name = temp;
      }
      notifyListeners();
    });
    final ref = db.collection('lists').doc(id).collection('shopps');
    ref.snapshots().listen((event) {
      List<dynamic>? temp = [];
      for (var doc in event.docs) {
        temp.add(doc.data());
      }
      shopps = temp;
      notifyListeners();
    });
    final refref = db.collection('lists').doc(id).collection('recepies');
    refref.snapshots().listen((event) {
      List<dynamic>? temp = [];
      for (var doc in event.docs) {
        temp.add(doc.data());
      }
      recepies = temp;
      notifyListeners();
    });
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

  List<Widget> getItemWidget(items) {
    List<Widget> res = [];
    for (Map<String, dynamic> e in items) {
      double l = e['name'].length;
      res.add(Container(
          color: Colors.blue,
          child: Wrap(spacing: (100 - l), children: [
            Text(e['name']),
            Text(e['price'].toString()),
            ElevatedButton(
                onPressed: () {
                  //edit(e);
                },
                child: const Text('Edit item')),
          ])));
    }
    return res;
  }

  List<Widget> getRecepieWidget(edit) {
    List<Widget> res = [];
    for (Map<String, dynamic> e in recepies) {
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
