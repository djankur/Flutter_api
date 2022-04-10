import 'dart:async';
import 'dart:convert';
//import 'package:delete/delete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Fetch extends StatefulWidget {
  const Fetch({Key? key}) : super(key: key);

  @override
  _FetchState createState() => _FetchState();
}

class _FetchState extends State<Fetch> {
  Future<List<Data>> getData() async {
    var response =
        await http.get(Uri.parse('http://54.254.31.24:8000/orders/'));
    print(response.body);
    var jsonData = jsonDecode(response.body);
    List<Data> dataList = [];
    for (var u in jsonData) {
      Data data = Data(u["title"]);
      dataList.add(data);
    }

    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Fetch"),
      ),
      body: Card(
        child: FutureBuilder<List<Data>>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Text("Loading");
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(snapshot.data![i].title),
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
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}

class Data {
  final String title;

  Data(this.title);
}
