import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:chatonline/app/pages/homePage/allChats.dart';
import 'package:chatonline/app/pages/homePage/login.dart';
import 'package:chatonline/app/pages/homePage/waiting.dart';
import 'package:chatonline/app/pages/newChatPage/newChat.dart';
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

  void logout() {
    ControlFirebase.instance.signOut();
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
      appBar: builAppBar(),
      backgroundColor: Colors.deepPurpleAccent,
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          String uid = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewChat()));
          verificateUid(uid);
        },
      ),
    );
  }

  PreferredSizeWidget builAppBar() {
    if (state != programState.logged) {
      return PreferredSize(
        preferredSize: Size(0, 0),
        child: Container(),
      );
    } else {
      return AppBar(
        title: Text("ChatApp"),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            alignment: Alignment.centerLeft,
            icon: Icon(Icons.exit_to_app),
            onPressed: logout,
          ),
        ],
      );
    }
  }

  Widget buildBody() {
    if (state == programState.waiting) {
      return Waiting();
    } else if (state == programState.notLogged) {
      return Login(doLogin);
    } else {
      return AllChats();
    }
  }

  void verificateUid(String uid) {
    //TODO
  }
}
