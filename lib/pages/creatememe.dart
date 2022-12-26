// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateMeme extends StatefulWidget {
  const CreateMeme({Key? key}) : super(key: key);

  @override
  State<CreateMeme> createState() => _CreateMemeState();
}

class _CreateMemeState extends State<CreateMeme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Create Your Meme"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    onChanged: (v) {
                      // _user_name = v;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Image URL',
                        hintText: 'Masukkan URL Valid'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    onChanged: (v) {
                      // _user_name = v;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Top Text',
                        hintText: 'Top Text Mas'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    onChanged: (v) {
                      // _user_name = v;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Bottom Text',
                        hintText: 'Bottom Text'),
                  ),
                )
              ],
            )),
        bottomNavigationBar: Container(
          height: 50,
          margin: EdgeInsets.all(10),
          child: ElevatedButton(onPressed: () {}, child: Text('Submit')),
        ));
  }
}
