// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_new, prefer_final_fields, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:meme_app/pages/creatememe.dart';
import 'package:meme_app/pages/detailmeme.dart';
import 'package:meme_app/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home.dart';
import 'pages/leaderboard.dart';
import 'pages/mycreations.dart';
import 'pages/settings.dart';

String active_user = "";
String user_name = "";
String first_name = "";
String last_name = "";
String avatar = "";
final List<Widget> _screens = [
  Home(),
  Leaderboard(),
  MyCreations(),
  Settings()
];
int _current_index = 0;

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString('user_id') ?? "";
  return user_id;
}

void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('user_id');
  main();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == "") {
      runApp(MyLogin());
    } else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'home': (context) => Home(),
        'mycreations': (context) => MyCreations(),
        'leaderboard': (context) => Leaderboard(),
        'settings': (context) => Settings(),
      },
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Daily Meme Digest'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void savedfNamelName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      first_name = prefs.getString('fname') ?? "";
      user_name = prefs.getString('user_name') ?? "";
      last_name = prefs.getString('lname') ?? "";
      avatar = prefs.getString('ava') ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    savedfNamelName();
  }

  BottomNavigationBar myBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _current_index,
      fixedColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      // ignore: prefer_const_literals_to_create_immutables
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "Leaderboard",
          icon: Icon(Icons.leaderboard),
        ),
        BottomNavigationBarItem(
          label: "My Creation",
          icon: Icon(Icons.mood),
        ),
        BottomNavigationBarItem(
          label: "Setting",
          icon: Icon(Icons.settings),
        ),
      ],
      onTap: (int index) {
        setState(() {
          _current_index = index;
        });
      },
    );
  }

  FloatingActionButton myFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CreateMeme()));
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: _screens[_current_index],
      floatingActionButton: myFAB(),
      // drawer: myDrawer(),
      bottomNavigationBar: myBottomNavBar(),
    );
  }
}
