// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, non_constant_identifier_names, use_key_in_widget_constructors, unused_field, sort_child_properties_last, avoid_unnecessary_containers

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meme_app/main.dart';
import 'package:meme_app/pages/createaccount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Flutter Demo",
        theme: ThemeData(primarySwatch: Colors.purple),
        home: Login(),
        debugShowCheckedModeBanner: false);
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State {
  String _user_id = "";
  String _user_name="";
  String _user_password = "";
  String error_login = "";
  
  void doLogin() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160719064/memes/login.php"),
        body: {'user_name': _user_name, 'user_password': _user_password});

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("user_id", json['user_id'].toString());
        prefs.setString("user_name", _user_name);
        main();
      } else {
        setState(() {
          error_login = "Incorrect user or password";
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 200,
                height: 200,
                child: Image.asset("assets/images/memeface.png")),
            Container(
              child: Text(
                "Daily Image Digest",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.only(bottom: 20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (v) {
                        _user_name = v;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Masukkan Email Yang Valid'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                        obscureText: true,
                        onChanged: (v) {
                          _user_password = v;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Masukkan Password Yang Valid')),
                  )
                ],
              ),
            ),
            Container(
                height: 50,
                width: 300,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateAccount()));
                  },
                  child: const Text("Create Account",
                      style: TextStyle(color: Colors.purple)),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(color: Colors.purple)))),
                ),
                margin: EdgeInsets.only(top: 20, bottom: 15)),
            Container(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      doLogin();
                    },
                    child: Text('Login')))
          ]),
    ));
  }
}
