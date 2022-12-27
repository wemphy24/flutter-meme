// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meme_app/class/memes.dart';
import 'package:http/http.dart' as http;
import 'package:meme_app/main.dart';


class CreateMeme extends StatefulWidget {
  const CreateMeme({Key? key}) : super(key: key);

  @override
  State<CreateMeme> createState() => _CreateMemeState();
}

class _CreateMemeState extends State<CreateMeme> {
  final _formKey = GlobalKey<FormState>();
  String _url = "";
  String _top_text = "";
  String _bottom_text = "";

  
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
        body: 
        SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child:Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child:Text("Preview"),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _url != null? NetworkImage(_url):NetworkImage('https://t3.ftcdn.net/jpg/05/37/73/58/360_F_537735846_kufBp10E8L4iV7OLw1Kn3LpeNnOIWbvf.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  constraints: BoxConstraints.expand(height: 200),
                  child: 
                  Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Center(child: 
                          Text(
                            _top_text, 
                            style: Theme.of(context).textTheme.headline4, //style blm di atur font meme
                          ),
                        ),
                        Center(child: 
                          Text(_bottom_text, 
                            style: Theme.of(context).textTheme.headline4, //style blm di atur font meme
                          ),
                        )
                    ],)]
                  )
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    onChanged: (v) {
                      setState(() {
                        _url = v;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Image URL',
                      hintText: 'Masukkan URL Valid'),
                    validator: (value) {
                      if (value == null || !Uri.parse(value).isAbsolute) {
                        return 'url salah';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    onChanged: (v) {
                      setState(() {
                        _top_text = v;
                      });
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
                      setState(() {
                        _bottom_text = v;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Bottom Text',
                      hintText: 'Bottom Text'),
                    ),
                  )
                ],
              )
            )
        ),
        bottomNavigationBar: Container(
        height: 50,
        margin: EdgeInsets.all(10),
        child: ElevatedButton(onPressed: () { 
          if (_formKey.currentState != null &&
              !_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Harap Isian diperbaiki')));
          } else {
            submit();
          }
        }, child: Text('Submit')),
      )
    );
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160719064/memes/new_meme.php"),
        body: {
          'url': _url,
          'top_text': _top_text,
          'bottom_text': _bottom_text,
          'users_id':active_user
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sukses Menambah Data')));
        Navigator.pop(context);
      }
    } else {
      throw Exception('Failed to read API');
    }
  }
}
