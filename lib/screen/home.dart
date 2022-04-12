import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/shared_pref_service.dart';
import 'login.dart';
import 'dart:async';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List> getData() async {
    var response =
        await http.get(Uri.parse('http://54.254.31.24:8000/orders/'));
    print(response.body);
    var jsonData = jsonDecode(response.body);
    List dataList = [];
    for (var u in jsonData) {
      String data = (u["delivery_address"]);
      dataList.add(data);
    }

    return dataList;
  }

  final PrefService pref = PrefService();
  void initState() {
    // TODO: implement initState
    super.initState();
    pref.readCache("token"); // read token
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: ElevatedButton(onPressed: () {}, child: Text("")),
            ),
            ListTile(
              title: const Text('LogOut'),
              onTap: () async {
                await pref.removeCache("token").whenComplete(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => Login()));
                });
              },
            ),
          ],
        ),
      ),
      body: Card(
        child: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Text("Loading");
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    return Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot.data![i]),
                          const SizedBox(width: 50),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => const Delete()),
                              // );
                            },
                            child: const Text('Delete'),
                          ),
                          const SizedBox(width: 50),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: () {},
                            child: const Text('update'),
                          ),
                        ],
                      ),
                    ]);
                  });
            }
          },
        ),
      ),
    );
  }
}
