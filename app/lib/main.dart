import 'package:flutter/material.dart';
import 'shopping_list.dart';
// import 'dart:io';
// import 'dart:convert';
//import 'test.json';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App Demo Shoppinglist Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;
  int _count = 0;
  List<String> items = [
    'wow',
    'wooow',
    'wwwoowwwww',
    'ff',
  ];
  List<int> list = <int>[];

  List<Product> productlist = <Product>[
    Product(name: "mjölk", type: "Dairy"),
    Product(name: "Coffee", type: "Beans")
  ];

  List<ShoppingList> shop = <ShoppingList>[
    ShoppingList(name: "List 1", products: <Product>[
      Product(name: "mjölk", type: "Dairy"),
      Product(name: "Coffee", type: "Beans")
    ]),
    ShoppingList(name: "Mat", products: <Product>[
      Product(name: "Mjöl", type: "Dairy"),
      Product(name: "Coffee", type: "Beans")
    ])
  ];

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: //Text('You have added $_count lists.\n $list'),
              GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of items in each row
          mainAxisSpacing: 8.0, // spacing between rows
          crossAxisSpacing: 8.0, // spacing between columns
        ),
        padding: const EdgeInsets.all(8.0), // padding around the grid
        itemCount: shop.length, // total number of items
        itemBuilder: (context, index) {
          return Container(
              color: Colors.blue, // color of grid items
              child: Column(
                children: [
                  Text(shop[index].toString()),
                  Text(shop[index].products[0].name)
                ],
              ));
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _count++;
          shop.add(ShoppingList(
              name: _count.toString(),
              products: <Product>[Product(name: "TEST", type: "TEST")]));
        }),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
      ),
    );
  }
}
