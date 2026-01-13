import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:mini_008/firebase_options.dart';
import 'package:mini_008/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    print("Firebase Initialize");
  });
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
      ),
      home: const MyHomePage(title: 'Login Form'),
      debugShowCheckedModeBanner: false,
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
  bool is_password_visible = false;
  String username = "";
  String password = "";

  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // db.collection("collection test").doc("init").set({"init": true});

    // db.collection("collection test").doc("init").delete();
    // db.collection("collection credential").doc("init").set({});

    // db.collection("collection credential").add({
    //  "username": "admin",
    //"password": "admin",
    // });

    // db.collection("collection credential").add({
    //     "username": "user",
    //     "password": "user",
    //   });
    //   db.collection("collection credential").get().then((q) {
    //     for (var doc in q.docs) {
    //       print(doc.data());
    //     }
    //   });
    // }

    //search
    // db
    //     .collection("collection credential")
    //     .where("username", isEqualTo: "user")
    //     .get()
    //     .then((q) {
    //       print(q.docs.first.data());
    //       {}
    //     });

    //update
    // db
    //     .collection("collection_credential")
    //     .where("username", isEqualTo: "user")
    //     .get()
    //     .then((q) {
    //       for (var doc in q.docs) {
    //         doc.reference.update({
    //           "username": "user_updated",
    //           "password": "user_updated",
    //         });
    //       }
    //     });

    //delete
    // db
    //     .collection("collection credential")
    //     .where("username", isEqualTo: "for_deletion")
    //     .get()
    //     .then((q) {
    //       for (var doc in q.docs) {
    //         doc.reference.delete();
    //       }
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Spacer(),
                Text("Username:"),
                SizedBox(
                  width: 300,
                  child: TextField(controller: controller_username),
                ),
                Spacer(),
              ],
            ),
            Row(
              children: [
                Spacer(),
                Text("Password:"),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: controller_password,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          is_password_visible = !is_password_visible;
                          setState(() {});
                        },

                        icon: is_password_visible
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      ),
                    ),
                    obscureText: !is_password_visible,
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Spacer(),
                OutlinedButton(
                  onPressed: () {
                    username = controller_username.text;
                    password = controller_password.text;

                    db
                        .collection("collection_credential")
                        .where("username", isEqualTo: username)
                        .where("password", isEqualTo: password)
                        .get()
                        .then((q) {
                          if (q.docs.isEmpty) {
                            print("Logic failed.");
                          } else {
                            print("Logic success.");
                          }
                        });

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         applicationPage(title: "Application Form"),
                    //   ),
                    // );
                  },
                  child: Text("Login"),
                ),
                SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            registerPage(title: "Register Form"),
                      ),
                    );
                  },
                  child: Text("Register"),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
