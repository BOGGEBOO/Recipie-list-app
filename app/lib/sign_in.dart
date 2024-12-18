//packages
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toggle_switch/toggle_switch.dart';

//Own packages
import 'main.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final auth = FirebaseAuth.instance;
  String email = "";
  String pass = "";
  String name = "";
  bool isNewUser = false;
  bool toggled = false;
  String buttText = "Sign in";
  // String? uid;
  Text updateButt() {
    return Text(buttText);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Sign In"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(hintText: 'Enter Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  }),
              TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    pass = value;
                  },
                  decoration: InputDecoration(hintText: 'Enter Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    final regex =
                        RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
                    if (value != null) {
                      if (regex.hasMatch(value)) {
                        return null;
                      } else {
                        return 'Password must consist of at least eight characters and one number';
                      }
                    }
                    return null;
                  }),
              TextFormField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter Name (New account only)'),
                  validator: (value) {
                    if (isNewUser == true && (value == null || value.isEmpty)) {
                      return 'Please enter a name';
                    }

                    return null;
                  }),
              ToggleSwitch(
                initialLabelIndex: toggled ? 0 : 1,
                totalSwitches: 2,
                labels: ['Sign in', 'Register'],
                activeBgColor: [Colors.green],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.grey[900],
                onToggle: (index) {
                  toggled = !toggled;
                  if (index == 0) {
                    isNewUser = false;
                    buttText = 'Sign in';
                  } else {
                    isNewUser = true;
                    buttText = 'Register';
                  }
                  setState(() {});
                },
              ),
              FloatingActionButton(
                onPressed: () async {
                  if (isNewUser == false) {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final user = await auth.signInWithEmailAndPassword(
                            email: email, password: pass);
                        if (user != null) {
                          final String? uid = user.user?.uid;
                          print(uid);
                          //db.collection('lists').doc(uid);
                          context.go('/list');
                        }
                      } catch (e) {
                        print(e);
                        showDialog(
                            context: context,
                            builder: (BuildContext) {
                              return AlertDialog(
                                title: const Text('Login Error'),
                                content: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        'The provided information is not correct, ensure it is correct and try again')),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      child: const Text("OK"))
                                ],
                              );
                            });
                      }
                    }
                  } else {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final newUser =
                            await auth.createUserWithEmailAndPassword(
                                email: email, password: pass);
                        if (newUser != null) {
                          // auth.currentUser.uid;
                          final String? uid = newUser.user?.uid;
                          print(uid);
                          db.collection('lists').doc(uid).set({'name': name});
                          db.collection('lists').doc(uid).collection('shopps');
                          db
                              .collection('lists')
                              .doc(uid)
                              .collection('recepies');
                          context.go('/list');
                        }
                      } catch (e) {
                        print(e);
                        showDialog(
                            context: context,
                            builder: (BuildContext) {
                              return AlertDialog(
                                title: const Text('Login Error'),
                                content: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        'The provided information is not correct, ensure it is correct and try again')),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      child: const Text("OK"))
                                ],
                              );
                            });
                      }
                    }
                  }
                },
                child: updateButt(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
