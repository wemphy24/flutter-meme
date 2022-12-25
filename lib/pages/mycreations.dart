// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unnecessary_new, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meme_app/main.dart';

class MyCreations extends StatefulWidget {
  const MyCreations({Key? key}) : super(key: key);

  @override
  State<MyCreations> createState() => _MyCreationsState();
}

class _MyCreationsState extends State<MyCreations> {
  Card myCard() {
    return Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage(
                      'https://media.sproutsocial.com/uploads/meme-example.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    child: Text("20 Desember 2022 18:30"))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                        // ...
                      },
                    ),
                    Text("150 likes")
                  ],
                ),
                Row(
                  children: [
                    Text("5 comments"),
                    IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () {
                        // ...
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [myCard(), myCard(), myCard()],
          )),
    );
  }
}
