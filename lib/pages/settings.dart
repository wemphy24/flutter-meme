// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
            child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text('Wemphy Stephian Philipe',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                )),
            Text('Active since Sept 2022'),
            Text('wemphysp@gmail.com'),
            // ignore: prefer_const_literals_to_create_immutables
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First Name',
                          hintText: 'First Name'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last Name',
                          hintText: 'Last Name'),
                    ),
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
                          ;
                        },
                        child: Text('Save Changes')),
                  ),
                ],
              ),
            )
          ],
        )),
      ],
    )));
  }
}
