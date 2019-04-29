import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './app_screen/details.dart';
import './utils/loader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUser() async {
    var data = await http
        .get("http://www.json-generator.com/api/json/get/bVMHycnXuG?indent=2");

    var jsonData = jsonDecode(data.body);

    List<User> users = [];

    for (var u in jsonData) {
      User user = User(u["id"], u["picture"], u["name"], u["age"], u["phone"],
          u["email"], u["greeting"]);
      users.add(user);
    }
    print(users);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: FutureBuilder(
            future: _getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Loader(),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int id) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data[id].picture),
                      ),
                      title: Text(snapshot.data[id].name),
                      subtitle: Text(snapshot.data[id].email),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(snapshot.data[id])));
                      },
                    );
                  },
                );
              }
            },
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class User {
  final int id;
  final String picture;
  final String name;
  final int age;
  final String phone;
  final String greeting;
  final String email;

  User(this.id, this.picture, this.name, this.age, this.phone, this.email,
      this.greeting);
}
