// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:meme_app/class/memes.dart';
import 'package:meme_app/main.dart';

class DetailMeme extends StatefulWidget {
  int memeID;
  DetailMeme({super.key, required this.memeID});

  @override
  State<DetailMeme> createState() => _DetailMemeState();
}

class _DetailMemeState extends State<DetailMeme> {
  Memes? _lm;

  final _formKey = GlobalKey<FormState>();
  String _comment = "";

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160719064/memes/detail_meme.php"),
        body: {'id': widget.memeID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      _lm = Memes.fromJson(json['data']);
      setState(() {});
    });
  }

  Future onGoBack(dynamic value) async {
    //	 print("masuk goback");
    setState(() {
      bacaData();
    });
  }

  Widget myCard() {
    if (_lm == null) {
      return const CircularProgressIndicator();
    }
    return Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
                height: 250.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(_lm!.url),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Text(
                          _lm!.top_text,
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              shadows: const [
                                Shadow(
                                    color: Colors.white,
                                    offset: Offset(1, 2),
                                    blurRadius: 2)
                              ],
                              fontFamily: 'Impact'),
                        ),
                      ),
                      Center(
                        child: Text(
                          _lm!.bottom_text,
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              shadows: const [
                                Shadow(
                                    color: Colors.white,
                                    offset: Offset(1, 2),
                                    blurRadius: 2)
                              ],
                              fontFamily: 'Impact'),
                        ),
                      )
                    ],
                  )
                ])),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      color: _lm!.likes != 0 ? Colors.red : Colors.grey[200],
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                        setState(() {
                          sendLike(_lm!.id);
                          bacaData();
                        });
                      },
                    ),
                    Text(
                      _lm!.likes.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ));
  }

  Widget commentCard() {
    if (_lm == null) {
      return const CircularProgressIndicator();
    }
    return SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _lm?.comments?.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Card(
                  color: Colors.grey[350],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _lm!.comments?[index]['username'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                        (_lm!.comments?[index]['date'])
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                  ]),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(_lm!.comments?[index]['comment']))
                          ])));
            }));
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Meme Detail"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                myCard(),
                commentCard(),
              ],
            )),
        bottomNavigationBar: Container(
            margin: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                // First child is enter comment text input
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                      hintText: 'Write Comments',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onChanged: (value) {
                      _comment = value;
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        !_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Harap Isian diperbaiki')));
                    } else {
                      sendComment();
                    }
                  },
                )
              ]),
            )));
  }

  void sendComment() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160719064/memes/new_comment.php"),
        body: {
          'meme_id': widget.memeID.toString(),
          'users_id': active_user,
          'comment': _comment.toString()
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sukses Menambah Data')));
        _comment = "";
        bacaData();
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  void sendLike(memeID) async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160719064/memes/cek_like.php"),
        body: {'meme_id': memeID.toString(), 'user_id': active_user});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'Sudah Like') {
        if (!mounted) return;
        final response = await http.post(
            Uri.parse("https://ubaya.fun/flutter/160719064/memes/dislike.php"),
            body: {
              'meme_id': memeID.toString(),
              'user_id': active_user,
            });
        if (response.statusCode == 200) {
          Map json = jsonDecode(response.body);
          if (json['result'] == 'success') {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cancel Like Sukses')));
            bacaData();
          }
        }
      } else {
        final response = await http.post(
            Uri.parse(
                "https://ubaya.fun/flutter/160719064/memes/update_like.php"),
            body: {
              'meme_id': memeID.toString(),
              'user_id': active_user,
            });
        if (response.statusCode == 200) {
          Map json = jsonDecode(response.body);
          if (json['result'] == 'success') {
            if (!mounted) return;
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Like Sukses')));
            bacaData();
          }
        }
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  void cancelLike(memeID) async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160719064/memes/disslike.php"),
        body: {
          'meme_id': memeID.toString(),
          'user_id': active_user,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Cancel Like Sukses')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }
}
