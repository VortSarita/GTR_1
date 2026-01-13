import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Register());
}

class Register extends StatelessWidget {
  const Register({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const registerPage(title: 'Register Form'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class registerPage extends StatefulWidget {
  const registerPage({super.key, required this.title});

  final String title;

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  bool is_password_visible = false;
  bool is_password_verify = false;

  String username = "";
  String password = "";
  String verify_password = "";

  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();
  TextEditingController controller_verify_password = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

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
                Container(
                  alignment: Alignment.centerRight,
                  width: 120,
                  child: Text("Username:"),
                ),
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
                Container(
                  alignment: Alignment.centerRight,
                  width: 120,
                  child: Text("Password:"),
                ),
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
            Row(
              children: [
                Spacer(),
                Container(
                  alignment: Alignment.centerRight,
                  width: 120,
                  child: Text("Verify Password:"),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: controller_verify_password,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          is_password_verify = !is_password_verify;
                          setState(() {});
                        },
                        icon: is_password_verify
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      ),
                    ),
                    obscureText: !is_password_verify,
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 20),

            OutlinedButton(
              onPressed: () {
                username = controller_username.text;
                password = controller_password.text;
                verify_password = controller_verify_password.text;

                if (verify_password == password) {
                  print("verify password incorrect");
                  return;
                }
                if (username.length < 5) {
                  print("username shorter than 5");
                  return;
                }

                db.collection("collection_credential").add({
                  "username": username,
                  "password": password,
                });
                print("register success.");
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
