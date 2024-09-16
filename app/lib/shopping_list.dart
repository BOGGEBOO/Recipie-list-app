class Product {
  String name;
  String type;

  Product({required this.name, required this.type});

  static Product fromJson(json) =>
      Product(name: json['productname'], type: json['type']);
}

class ShoppingList {
  String name;
  List<Product> products;

  ShoppingList({required this.name, required this.products});

  static ShoppingList fromJson(json) =>
      ShoppingList(name: json['listname'], products: json['products']);
}
