// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, unused_field, prefer_final_fields, prefer_const_constructors_in_immutables

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:meme_app/class/memes.dart';
import 'package:http/http.dart' as http;
import 'package:meme_app/class/users.dart';
import 'package:meme_app/main.dart';
import 'dart:convert';

import 'package:meme_app/pages/home.dart';
import 'package:path_provider/path_provider.dart';

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
      privacy: 0);

  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();

  File? _image;
  File? _imageProses;

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
        if (du.privacy == 1) {
          privacyChecked = true;
        }
      });
    });
  }

  _imgGaleri() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 600);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
      prosesFoto();
    });
  }

  _imgKamera() async {
    final picker = ImagePicker();
    final image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 20);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
      prosesFoto();
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      tileColor: Colors.white,
                      leading: Icon(Icons.photo_library),
                      title: Text('Galeri'),
                      onTap: () {
                        _imgGaleri();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: const Text('Kamera'),
                    onTap: () {
                      _imgKamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void prosesFoto() {
    Future<Directory?> extDir = getTemporaryDirectory();
    extDir.then((value) {
      String timestamp = DateTime.now().toString();
      final String filePath = '${value?.path}/$timestamp.jpg';
      _imageProses = File(filePath);
      img.Image? temp = img.readJpg(_image!.readAsBytesSync());
      img.Image temp2 = img.copyResize(temp!, width: 480, height: 640);
      setState(() {
        _imageProses?.writeAsBytesSync(img.writeJpg(temp2));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  void submit() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160719064/memes/update_profile.php"),
        body: {
          'first_name': du.first_name,
          'last_name': du.last_name,
          'privacy': du.privacy.toString(),
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
        if (_imageProses == null) return;
        List<int> imageBytes = _imageProses!.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        final response2 = await http.post(
            Uri.parse(
                'https://ubaya.fun/flutter/160719064/memes/upload_avatar.php'),
            body: {
              'user_id': active_user,
              'image': base64Image,
            });
        if (response2.statusCode == 200) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Sukses Mengubah Data')));
        }
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Setting"),
          // leading: GestureDetector(
          //   onTap: () {/* Write listener code here */},
          //   child: Icon(
          //     Icons.menu, // add custom icons also
          //   ),
          // ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange, shape: BoxShape.circle),
                      child: IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          setState(() {
                            doLogout();
                          });
                        },
                      )),
                )),
          ],
        ),
        body: Center(
            child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _imageProses != null
                          ? FileImage(_imageProses!)
                          : NetworkImage(du.avatar) as ImageProvider,
                      fit: BoxFit.cover,
                    )),
              ),
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
                              if (privacyChecked == true) {
                                du.privacy = 1;
                              } else {
                                du.privacy = 0;
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
                                          content:
                                              Text('Harap Isian diperbaiki')));
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
