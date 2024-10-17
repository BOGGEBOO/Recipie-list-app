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
  bool isNewUser = false;
  bool toggled = false;
  String buttText = "Sign in";
  // String? uid;
  Text updateButt() {
    return Text(buttText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("widget.title"),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(hintText: 'Enter Email'),
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                pass = value;
              },
              decoration: InputDecoration(hintText: 'Enter Password'),
            ),
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
                    print(e); //TODO replace with error page
                  }
                } else {
                  try {
                    final newUser = await auth.createUserWithEmailAndPassword(
                        email: email, password: pass);
                    if (newUser != null) {
                      // auth.currentUser.uid;
                      final String? uid = newUser.user?.uid;
                      print(uid);
                      db
                          .collection('lists')
                          .doc(uid)
                          .set({'name': 'WOW', 'shopps': [], 'receipes': []});
                      context.go('/list');
                    }
                  } catch (e) {
                    print(e); //TODO replace with error page
                  }
                }
              },
              child: updateButt(),
            )
          ],
        ),
      ),
    );
  }
}
