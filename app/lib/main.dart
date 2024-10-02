import 'package:flutter/material.dart';
import 'shopping_list.dart';
import 'package:go_router/go_router.dart';
import 'recepies.dart';
import 'account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

//import 'recepies.dart';
// import 'dart:io';
// import 'dart:convert';
//import 'test.json';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MyApp(),
  );
}

final db = FirebaseFirestore.instance;

final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return const MyHomePage(title: "title");
    },
  ),
  GoRoute(
    path: '/recepies',
    builder: (BuildContext context, GoRouterState state) {
      return Recepies();
    },
  ),
  GoRoute(
      path: '/account',
      builder: (BuildContext context, GoRouterState state) {
        return Account();
      })
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ShoppList('0'),
        child: MaterialApp.router(
          routerConfig: _router,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        ));
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

  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('lists').snapshots();

  String name = "";
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: _userStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('FEEL');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('loading');
            }

            return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                padding: const EdgeInsets.all(8.0),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Container(
                    color: Colors.blue,
                    child: Column(
                      children: [
                        Text(document.id),
                        Text(data['name']),
                        ElevatedButton(
                            onPressed: () {
                              name = "Coolt";
                              final ref =
                                  db.collection('lists').doc(document.id);
                              ref.update({'name': name});
                            },
                            child: Text("Ändra till Coolt")),
                        ElevatedButton(
                            onPressed: () {
                              name = "Inte coolt";
                              final ref =
                                  db.collection('lists').doc(document.id);
                              ref.update({'name': name});
                            },
                            child: Text("Ändra till Inte coolt")),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       final ref =
                        //           db.collection('lists').doc(document.id);
                        //       ref.update({'name': name});
                        //     },
                        //     child: const Text("update")),
                      ],
                    ),
                  );
                }).toList());
          }),
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
        onTap: (int index) {
          switch (index) {
            case 0:
              context.go('/');
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

class ShoppList extends ChangeNotifier {
  List<Map<String, dynamic>> _items = [];
  String test = "";

  ShoppList(id) {
    print(id);
    final listRef = db.collection("lists").doc(id);
    listRef.snapshots().listen(
      (event) {
        test = event.data()?['test'];
        _items = event.data()?['shopps'];
        print("oooooooooooooo");
        notifyListeners();
      },
      onError: (error) => print("listen failed: $error"),
    );
  }
}
