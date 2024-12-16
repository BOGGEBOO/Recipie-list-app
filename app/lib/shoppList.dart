//packages
import 'package:app/public.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//Own classes
import 'main.dart';

class ShoppList extends ChangeNotifier {
  String? id;
  String? name;
  List shopps = [];
  List recepies = [];
  List public = [];
  ThemeMode theme = ThemeMode.light;
  bool _isDark = false;

  bool get isDark => _isDark;

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
    final publicref = db.collection('public');
    publicref.snapshots().listen((event) {
      List<dynamic>? temp = [];
      for (var doc in event.docs) {
        temp.add(doc.data());
      }
      public = temp;
      notifyListeners();
    });
  }

  String? getName() {
    return name;
  }

  List<Widget> getShoppWidget(edit, remove) {
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
            ElevatedButton(
                onPressed: () {
                  remove(e);
                },
                child: const Text('Remove list')),
          ])));
    }
    return res;
  }

  List<Widget> getItemWidget(items, edit) {
    List<Widget> res = [];
    for (Map<String, dynamic> e in items) {
      res.add(Container(
          color: const Color.fromARGB(255, 198, 219, 234),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              width: 150,
              alignment: Alignment.centerLeft,
              child: Text(e['name']),
            ),
            Container(
              width: 180,
              alignment: Alignment.center,
              child: Text(e['price'].toString()),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: () {
                    edit(e);
                  },
                  child: const Text('Remove item')),
            )
          ])));
    }
    return res;
  }

  List<Widget> getRecepieWidget(edit, remove) {
    List<Widget> res = [];
    for (Map<String, dynamic> e in recepies) {
      res.add(Container(
          color: Colors.blue,
          child: Column(children: [
            Text(e['name']),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      edit(e);
                    },
                    child: const Text('Edit list')),
                SizedBox(
                  width: 100,
                ),
                ElevatedButton(
                    onPressed: () {
                      remove(e);
                    },
                    child: const Text('Remove Recepie')),
              ],
            )
          ])));
    }
    return res;
  }

  List<Widget> getIngridientWidget(ingridients) {
    List<Widget> res = [];
    for (Map<String, dynamic> e in ingridients) {
      res.add(Container(
          color: const Color.fromARGB(255, 168, 195, 214),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                e['id'].toString(),
                style: TextStyle(fontSize: 30),
              ),
              Expanded(
                  child: Text(
                e['disc'],
                //overflow: TextOverflow.ellipsis,
              ))
            ],
          )));
    }
    return res;
  }

  List<Widget> getPublicWidget(view) {
    List<Widget> res = [];
    for (Map<String, dynamic> e in public) {
      res.add(Container(
          color: Colors.blue,
          child: Column(children: [
            Text(e['name']),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      view(e);
                    },
                    child: const Text('view recepie')),
              ],
            )
          ])));
    }
    return res;
  }

  List<Widget> getPublicItemWidget(items) {
    List<Widget> res = [];
    for (Map<String, dynamic> e in items) {
      res.add(Container(
          color: const Color.fromARGB(255, 198, 219, 234),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              width: 150,
              alignment: Alignment.centerLeft,
              child: Text(e['name']),
            ),
            Container(
              width: 180,
              alignment: Alignment.center,
              child: Text(e['price'].toString()),
            ),
          ])));
    }
    return res;
  }

  void toggleTheme(value) {
    _isDark = value;
    if (theme == ThemeMode.light) {
      theme = ThemeMode.dark;
    } else {
      theme = ThemeMode.light;
    }
    notifyListeners();
  }

  ThemeMode get themeMode => theme;
}
