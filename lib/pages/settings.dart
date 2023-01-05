// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, unused_field, prefer_final_fields, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meme_app/class/memes.dart';
import 'package:http/http.dart' as http;
import 'package:meme_app/main.dart';
import 'dart:convert';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  Memes _dataMeme = Memes(
    id: 0,
    url: '',
    top_text: '',
    bottom_text: '',
    date: '',
    likes: 0,
    user_id: 0,
  );

  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();

  void getfNamelName() async {
    setState(() {
      _fnameController.text = first_name;
      _lnameController.text = last_name;
    });
  }

  void submit() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160719064/memes/update_profile.php"),
        body: {
          'first_name': first_name,
          'last_name': last_name,
          'user_id': active_user.toString()
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses mengubah Data')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  void initState() {
    super.initState();
    getfNamelName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    "https://assets.promediateknologi.com/crop/33x301:541x953/x/photo/2022/04/07/3381014888.png"),
                fit: BoxFit.cover,
              )),
        ),
        Container(
            child: Form(
          key: _formKey,
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text('$first_name $last_name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  )),
              Text('Active since Sept 2022'),
              Text(user_name),
              // ignore: prefer_const_literals_to_create_immutables
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'First Name',
                              hintText: 'First Name'),
                          onChanged: (value) {
                            first_name = value;
                          },
                          controller: _fnameController),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Last Name',
                              hintText: 'Last Name'),
                          onChanged: (value) {
                            last_name = value;
                          },
                          controller: _lnameController),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 300,
                      child: ElevatedButton(
                          onPressed: () {
                            var state = _formKey.currentState;
                            if (state == null || !state.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Harap Isian diperbaiki')));
                            } else {
                              submit();
                            }
                          },
                          child: Text('Save Changes')),
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ],
    )));
  }

  void submitChanges() async {}
}
