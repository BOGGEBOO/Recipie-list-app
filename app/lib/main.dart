//packages
import 'package:app/edit_recepie.dart';
import 'package:app/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Own classes
import 'recepies.dart';
import 'account.dart';
import 'edit_list.dart';
import 'shoppList.dart';

//TODO inloggning/konto & kolla på FutureBuilder

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: ((context) => ShoppList.instance(user?.uid)))
    ],
    child: const MyApp(),
  ));
}

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(
    path: '/list',
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
      }),
  GoRoute(
      path: '/edit',
      builder: (BuildContext context, GoRouterState state) {
        final items = state.extra! as Map<String, dynamic>;
        return EditList(
          items: items,
        );
      }),
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SignIn();
      }),
  GoRoute(
      path: '/editRec',
      builder: (BuildContext context, GoRouterState state) {
        final items = state.extra! as Map<String, dynamic>;
        return EditRecepie(items: items);
      })
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
  int _count = 0;

  // final Stream<QuerySnapshot> _userStream =
  //     FirebaseFirestore.instance.collection('lists').snapshots();

  void edit(Map<String, dynamic> items) {
    context.push('/edit', extra: items);
  }

  void remove(Map<String, dynamic> items) {
    //context.push('/edit', extra: items);
    db
        .collection('lists')
        .doc(user?.uid)
        .collection('shopps')
        .doc(items['name'])
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          padding: const EdgeInsets.all(8.0),
          children: context.watch<ShoppList>().getShoppWidget(edit, remove)),
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
                              .collection('shopps')
                              .doc(controller.text)
                              .set({'name': controller.text, 'list': []});
                          context.pop();
                        },
                        child: const Text('create'))
                  ],
                );
              });

          _count++;
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
