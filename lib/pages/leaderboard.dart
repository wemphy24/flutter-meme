// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meme_app/class/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meme_app/main.dart';

class Leaderboard extends StatefulWidget {
  Leaderboard({Key? key}) : super(key: key);
  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Users> users = [];

  Future<String> fetchData() async {
    final response = await http.post(
      Uri.parse('https://ubaya.fun/flutter/160719064/memes/get_userranks.php'),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    users.clear();
    Future<String> data = fetchData();
    data.then((value) {
      setState(() {
        Map json = jsonDecode(value);
        for (var user in json['data']) {
          Users mov = Users.fromJson(user);
          users.add(mov);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Daily Meme Digest")),
        body: ListView(padding: EdgeInsets.all(8), children: [
          Container(
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return listRanks(snapshot.data.toString());
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })),
        ]));
  }

  Widget listRanks(data) {
    List<Users> lr = [];
    Map json = jsonDecode(data);
    for (var ran in json['data']) {
      Users r = Users.fromJson(ran);
      lr.add(r);
    }
    return ListView.builder(
      itemCount: lr.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return Card(
          elevation: 4.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(10),
          child: Column(children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 80,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(lr[index].avatar),
                                fit: BoxFit.cover,
                              )),
                        ),
                        Text(lr[index].first_name + lr[index].last_name)
                      ],
                    ),
                    Row(children: [
                      IconButton(
                        color: Colors.red,
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          // ...
                        },
                      ),
                      Text("2100")
                    ])
                  ]),
            )
          ]),
        );
      },
    );
  }
}
