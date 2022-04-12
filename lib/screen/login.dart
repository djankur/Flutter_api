import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api/screen/fetch.dart';
import 'package:flutter_api/screen/signup.dart';
import 'package:flutter_api/services/comHelper.dart';
import 'package:http/http.dart' as http;

import '../services/shared_pref_service.dart';
import 'home.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final PrefService pref = PrefService();
  TextEditingController token = TextEditingController();
  TextEditingController username1 = TextEditingController();
  TextEditingController password1 = TextEditingController();
  dynamic tokenn;
  dynamic res;
  bool initialize = false;
  login(username, password) async {
    String usernames = username1.text;
    String passwords = password1.text;
    try {
      if (usernames.isEmpty) {
        alertDialog(context, "Please Enter User Name");
      } else if (passwords.isEmpty) {
        alertDialog(context, "Please Enter Password");
      }
      var url = Uri.parse('http://54.254.31.24:8000/auth/token');
      var response = await http.post(url, headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        "username": username,
        "password": password
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 401) {
        print("wrong");
        alertDialog(context, "Wrong Username and Password");
      }

      Map tokenn = jsonDecode(response.body);
      token.text = tokenn['token'];
      //print(tokenn['token']);
      if (response.statusCode == 200) {
        pref.createCache(token.text).whenComplete(() {
          initialize = true;
          alertDialog(context, "Successfull");
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => Home()));
        });
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
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: false,
                child: TextFormField(
                  controller: token,
                  decoration: InputDecoration(
                    hintText: "token",
                  ),
                ),
              ),
              TextFormField(
                controller: username1,
                decoration: InputDecoration(
                  hintText: "Username",
                ),
              ),
              TextFormField(
                controller: password1,
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
                  login(username1.text.toString(), password1.text.toString());
                  setState(() {});
                },
                child: Text('Login'),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => Signup()));
                },
                child: Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
