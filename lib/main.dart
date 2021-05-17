import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: DataFromApi(),
    );
  }
}

class DataFromApi extends StatefulWidget {
  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromApi> {
  Future getUserData() async {
    var response =
        await http.get(Uri.https('jsonplaceholder.typicode.com', 'todos'));
    var jsonData = jsonDecode(response.body);
    List<User> users = [];
    for (var us in jsonData) {
      User user = User(us['userId'], us['id'], us['title'], us['completed']);
      users.add(user);
    }
    print(users.length);
    return users;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List View"),
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text('Loading'),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(snapshot.data[i].id.toString()),
                      subtitle: Text(snapshot.data[i].title),
                      trailing: Text(snapshot.data[i].completed.toString()),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class User {
  int userId, id;
  String title;
  bool completed;
  User(int userId, int id, String title, bool completed) {
    this.userId = userId;
    this.id = id;
    this.title = title;
    this.completed = completed;
  }
}
