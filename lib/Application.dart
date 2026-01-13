import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mini_008/barcode_scanner.dart';
import 'package:mini_008/main.dart';
import 'firebase_options.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const applicationPage(title: 'Application Form'),
    );
  }
}

// ignore: camel_case_types
class applicationPage extends StatefulWidget {
  const applicationPage({super.key, required this.title});

  final String title;

  @override
  State<applicationPage> createState() => _applicationPageState();
}

class _applicationPageState extends State<applicationPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> search_products = [];

  TextEditingController controller_bar_code = TextEditingController();
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_country = TextEditingController();
  TextEditingController controller_search = TextEditingController();

  @override
  void initState() {
    super.initState();
    Init();
  }

  void Init() async {
    products.clear();
    search_products.clear();

    await db //
        .collection("collection_product")
        .orderBy("create_at", descending: true)
        .get()
        .then((q) {
          for (var d in q.docs) {
            // print(d.id);
            // print(d.data().containsKey("bar_code"));
            // print(d.data().containsKey("name"));
            // print(d.data().containsKey("country"));
            // print(d.get("create_at"));

            var data = {
              "id": d.id,
              "bar_code": d.data().containsKey("bar_code")
                  ? d.get("bar_code")
                  : "",
              "name": d.data().containsKey("name") ? d.get("name") : "",
              "country": d.data().containsKey("country")
                  ? d.get("country")
                  : "",
            };
            //print(data);
            products.add(data);
          }
        });
    void search() {
      search_products.clear();
      if (controller_search.text.isEmpty) {
        search_products = products;
      } else {
        search_products = products.where((p) {
          return p["bar_code"].toString().toLowerCase().contains(
            controller_search.text,
          );
        }).toList();
      }
    }

    setState(() {});
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 400,
                  child: TextField(
                    controller: controller_search,
                    onChanged: (t) {
                      Init();
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => const BarcodeScannerPage(),
                          ),
                        )
                        .then((v) {
                          if (v != null) {
                            controller_search.text = v.toString();
                            search();
                            setState(() {});
                          }
                        });
                  },
                  icon: Icon(Icons.barcode_reader),
                ),
              ],
            ),

            Expanded(
              child: ListView.builder(
                itemCount: search_products.length,
                itemBuilder: (c, i) {
                  Row(
                    children: [
                      Container(
                        width: 160,
                        alignment: Alignment.center,
                        child: OutlinedButton(
                          onPressed: () {
                            //controller_bar_code.text = products[i]["bar_code"];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Edit bar_code"),
                                  content: TextField(
                                    controller: controller_bar_code,
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () async {
                                        var id = search_products[i]["id"];
                                        await db
                                            .collection("collection_product")
                                            .doc(id)
                                            .update({
                                              "bar_code":
                                                  controller_bar_code.text,
                                            });
                                        controller_bar_code.text = "";
                                        Init();
                                        Navigator.pop(context);
                                      },
                                      child: Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(search_products[i]["bar_code"]),
                        ),
                      ),
                      Container(
                        width: 160,
                        alignment: Alignment.center,
                        child: OutlinedButton(
                          onPressed: () {
                            //controller_name.text = products[i]["name"];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Edit name"),
                                  content: TextField(
                                    controller: controller_name,
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () async {
                                        var id = search_products[i]["id"];
                                        await db
                                            .collection("collection_product")
                                            .doc(id)
                                            .update({
                                              "name": controller_name.text,
                                            });
                                        controller_name.text = "";
                                        Init();
                                        Navigator.pop(context);

                                        Init();
                                        setState(() {});
                                      },
                                      child: Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(search_products[i]["name"]),
                        ),
                      ),
                      Container(
                        width: 160,
                        alignment: Alignment.center,
                        child: OutlinedButton(
                          onPressed: () {
                            //controller_country.text = products[i]["country"];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Edit country"),
                                  content: TextField(
                                    controller: controller_country,
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () async {
                                        var id = search_products[i]["id"];
                                        await db
                                            .collection("collection_product")
                                            .doc(id)
                                            .update({
                                              "country":
                                                  controller_country.text,
                                            });
                                        controller_country.text = "";
                                        Init();
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(search_products[i]["country"]),
                        ),
                      ),

                      Spacer(),

                      IconButton(
                        onPressed: () async {
                          var id = search_products[i]["id"];
                          await db
                              .collection("collection_product")
                              .doc(id)
                              .delete();
                          Init();
                          setState(() {});
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //
          await db.collection("collection_product").add({
            "create_at": DateTime.now(),
          });
          Init();
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void search() {}
}
