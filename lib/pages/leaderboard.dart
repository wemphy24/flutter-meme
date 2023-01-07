// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meme_app/class/rank.dart';
import 'package:meme_app/class/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meme_app/main.dart';

class Leaderboard extends StatefulWidget {
  // Leaderboard({Key? key}) : super(key: key);
  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Rank> ranks = [];

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
    ranks.clear();
    Future<String> data = fetchData();
    data.then((value) {
      setState(() {
        Map json = jsonDecode(value);
        for (var rank in json['data']) {
          Rank ra = Rank.fromJson(rank);
          ranks.add(ra);
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
    List<Rank> lr = [];
    Map json = jsonDecode(data);
    for (var ran in json['data']) {
      Rank r = Rank.fromJson(ran);
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
                        Text(lr[index].privacy != 1
                            ? lr[index].first_name + lr[index].last_name
                            : "${(lr[index].first_name + lr[index].last_name).substring(0, 3)}${(lr[index].first_name + lr[index].last_name).substring(3).replaceAll(RegExp(r'[a-zA-Z]'), '*')}")
                      ],
                    ),
                    Row(children: [
                      Icon(Icons.favorite, color: Colors.red),
                      Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(lr[index].total_likes)),
                    ])
                  ]),
            )
          ]),
        );
      },
    );
  }
}
