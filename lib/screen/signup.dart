import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api/services/comHelper.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'login.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   username.text = 'a';
  //   email.text = 'a';
  //   first_name.text = 'a';
  //   last_name.text = 'a';
  //   password.text = 'a';
  // }

  void create(username, email, first_name, last_name, password) async {
    try {
      var url = Uri.parse('http://54.254.31.24:8000/auth/create/user');
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "username": username,
            "email": email,
            "first_name": first_name,
            "last_name": last_name,
            "password": password
          }));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        alertDialog(context, "Successfully create account");
        Navigator.push(
            context, MaterialPageRoute(builder: (builder) => Login()));
      }
      // print(await http
      //     .read(Uri.parse('http://54.254.31.24:8000/auth/create/user')));
    } catch (e) {
      print(e.toString());
    }
  }

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: username,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Username",
                  ),
                ),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                ),
                TextFormField(
                  controller: first_name,
                  decoration: InputDecoration(
                    hintText: "First Name",
                  ),
                ),
                TextFormField(
                  controller: last_name,
                  decoration: InputDecoration(
                    hintText: "Last Name",
                  ),
                ),
                TextFormField(
                  controller: password,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      )),
                  //obscureText: false,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                      create(
                          username.text.toString(),
                          email.text.toString(),
                          first_name.text.toString(),
                          last_name.text.toString(),
                          password.text.toString());
                    },
                    child: Text('Sign Up')),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) => Login()));
                      });
                    },
                    child: Text('Login'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // post(Uri parse, {Map<String, dynamic> body}) {}
}
