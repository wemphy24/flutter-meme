// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meme_app/class/memes.dart';
import 'package:meme_app/pages/detailmeme.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _temp = 'waiting API respond…';
  List<Memes> memes = [];
  

  Future<String> fetchData() async {
    final response = 
      await http.post(Uri.parse('https://ubaya.fun/flutter/160719064/memes/get_allmemes.php'),
       // untuk mengirim data (form) yang akan dibaca di PHP dengan $_POST
      );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    //membersihkan list sebelum fetch data
    memes.clear();

    Future<String> data = fetchData();
    data.then((value) {
      setState(() {
        // mengolah JSON menjadi object Dart(POpMovie)
        Map json =jsonDecode(value);
        for(var meme in json['data']){
          Memes mov = Memes.fromJson(meme);
          memes.add(mov);
        }
        //uji coba
        // _temp = memes[0].url;
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
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // return Text(snapshot.data.toString());
                  return listMemes(snapshot.data.toString());
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }
            )
          ),
        ]
      ),
          
    );
  }

  Widget listMemes(data) {
    List<Memes> lm = [];
    Map json = jsonDecode(data);
    for (var mem in json['data']) {
      Memes m = Memes.fromJson(mem);
      lm.add(m);
    }
    return ListView.builder(
      itemCount: lm.length,
      itemBuilder: (BuildContext ctxt, int index) {
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
                    image: NetworkImage(
                        lm[index].url),
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
                          lm[index].top_text,
                          style: Theme.of(context)
                              .textTheme
                              .headline4, //style blm di atur font meme
                        ),
                      ),
                      Center(
                        child: Text(
                          lm[index].bottom_text,
                          style: Theme.of(context)
                              .textTheme
                              .headline4, //style blm di atur font meme
                        ),
                      )
                    ],
                  )
                ])            
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
                      Text(lm[index].likes.toString())
                    ],
                  ),
                  Container(
                      child: IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DetailMeme(memeID: lm[index].id)));
                    },
                  )),
                ],
              )
            ],
          )
        );
      }
    );
  }

}
