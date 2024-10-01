import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppList extends ChangeNotifier {
  final List<String> _items = [];

  void add(String item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
