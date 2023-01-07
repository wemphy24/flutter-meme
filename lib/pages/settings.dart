// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, unused_field, prefer_final_fields, prefer_const_constructors_in_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meme_app/class/memes.dart';
import 'package:http/http.dart' as http;
import 'package:meme_app/class/users.dart';
import 'package:meme_app/main.dart';
import 'dart:convert';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Users? _du;
  bool? privacyChecked = false;

  final _formKey = GlobalKey<FormState>();
  Users du = Users(
    id: 0,
    username: '',
    first_name: '',
    last_name: '',
    registration_date: '',
    avatar: '',
    privacy: 0
  );

  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160719064/memes/detail_user.php"),
        body: {'id': active_user});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  readData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      du = Users.fromJson(json['data']);
      setState(() {
        _fnameController.text = du.first_name;
        _lnameController.text = du.last_name;
        if(du.privacy==1){
          privacyChecked=true;
        }
      });
    });
  }

  // void getfNamelName() async {
  //   setState(() {
  //     _fnameController.text = first_name;
  //     _lnameController.text = last_name;
  //   });
  // }

  void submit() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160719064/memes/update_profile.php"),
        body: {
          'first_name': du.first_name,
          'last_name': du.last_name,
          'privacy': du.privacy,
          'user_id': active_user
        });
    if (response.statusCode == 200) {
      // print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Mengubah Data')));
        setState(() {
          readData();
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  void initState() {
    super.initState();
    readData();
    // getfNamelName();
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
                image: NetworkImage(du.avatar),
                fit: BoxFit.cover,
              )),
        ),
        Container(
            child: Form(
          key: _formKey,
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(du.first_name + " " + du.last_name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  )),
              Text('Active since ' +
                  du.registration_date), //ambil bulan dan tahunnya aja
              Text(du.username),
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
                            // border: OutlineInputBorder(),
                            labelText: 'First Name',
                          ),
                          onChanged: (value) {
                            du.first_name = value;
                          },
                          controller: _fnameController),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                          decoration: InputDecoration(
                            // border: OutlineInputBorder(),
                            labelText: 'Last Name',
                          ),
                          onChanged: (value) {
                            du.last_name = value;
                          },
                          controller: _lnameController),
                    ),
                    Container(
                        child: CheckboxListTile(
                      value: privacyChecked,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          privacyChecked = value!;
                          if(privacyChecked==true){
                            du.privacy =1;
                          }
                        });
                      },
                      title: Text("Hide my name"),
                    ))
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
