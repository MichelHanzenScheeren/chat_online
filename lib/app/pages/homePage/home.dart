import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:chatonline/app/pages/homePage/constructHome.dart';
import 'package:chatonline/app/pages/homePage/login.dart';
import 'package:chatonline/app/pages/homePage/waiting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum programState { waiting, logged, notLogged }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  programState state = programState.waiting;
  FirebaseUser currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initUser();
  }

  void initUser() async {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        currentUser = user;
        ControlFirebase.instance.currentUser = user;
        verifyLogin();
      });
    });
  }

  void verifyLogin() {
    if (currentUser != null) {
      setState(() => state = programState.logged);
    } else {
      setState(() => state = programState.notLogged);
    }
  }

  Future doLogin() async {
    try {
      await ControlFirebase.instance.login();
      verifyLogin();
    } catch (erro) {
      showSnackbar();
    }
  }

  void showSnackbar() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          "Não foi possível fazer o login!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: state == programState.logged
          ? AppBar(
              title: Text("ChatApp"),
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  padding: EdgeInsets.only(left: 0, right: 1),
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  padding: EdgeInsets.only(left: 0, right: 2),
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    ControlFirebase.instance.signOut();
                    state = programState.notLogged;
                  },
                ),
              ],
            )
          : PreferredSize(
              preferredSize: Size(0, 0),
              child: Container(),
            ),
      backgroundColor: Colors.deepPurpleAccent,
      body: state == programState.waiting
          ? Waiting()
          : (state == programState.notLogged
              ? Login(doLogin)
              : ConstructHome()),
    );
  }
}
