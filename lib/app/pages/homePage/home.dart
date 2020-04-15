import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool wasLogged = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatApp"),
        elevation: 0,
        actions: <Widget>[
          wasLogged
              ? IconButton(
                  padding: EdgeInsets.only(left: 0, right: 1),
                  icon: Icon(Icons.search),
                  onPressed: () {},
                )
              : Container(),
          wasLogged
              ? IconButton(
                  padding: EdgeInsets.only(left: 0, right: 2),
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {},
                )
              : Container(),
        ],
      ),
      backgroundColor: Colors.deepPurpleAccent,
    );
  }
}
