// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Daily Meme Digest")),
        body: SingleChildScrollView(
          child: Column(children: [
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                                    image: NetworkImage(
                                        "https://assets.promediateknologi.com/crop/33x301:541x953/x/photo/2022/04/07/3381014888.png"),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Text("Nurleila")
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
            )
          ]),
        ));
  }
}
