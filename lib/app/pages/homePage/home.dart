import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:chatonline/app/pages/chatPage/chat.dart';
import 'package:chatonline/app/pages/homePage/allChats.dart';
import 'package:chatonline/app/pages/homePage/login.dart';
import 'package:chatonline/app/pages/homePage/waiting.dart';
import 'package:chatonline/app/pages/newChatPage/newChat.dart';
import 'package:flutter/material.dart';

enum programState { waiting, logged, notLogged }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  programState state = programState.waiting;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ControlFirebase.instance.initUser(verifyLogin);
  }

  void verifyLogin() {
    if (ControlFirebase.instance.currentUser != null) {
      setState(() => state = programState.logged);
    } else {
      setState(() => state = programState.notLogged);
    }
  }

  Future doLogin() async {
    try {
      String nome = await ControlFirebase.instance.login();
      mySnackbar("Bem vindo, $nome!", Colors.green);
    } catch (erro) {
      mySnackbar("Não foi possível fazer o login!", Colors.red);
    }
  }

  void logout() {
    try {
      ControlFirebase.instance.signOut();
    } catch (erro) {
      mySnackbar("Não é possível fazer logout no momento!", Colors.red);
    }
  }

  void mySnackbar(String text, Color cor) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: cor,
        duration: Duration(seconds: 3),
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Future openPage(BuildContext context, dynamic page) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  void verificateUid(BuildContext context, String uid) async {
    if (uid == null) {
      return;
    } else {
      await openPage(context, Chat(uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.deepPurpleAccent,
      appBar: builAppBar(),
      body: buildBody(),
      floatingActionButton: buttonNewChat(context),
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
      return AllChats(openPage);
    }
  }

  Widget buttonNewChat(BuildContext context) {
    if (state == programState.logged) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          String uid = await openPage(context, NewChat());
          verificateUid(context, uid);
        },
      );
    } else {
      return Container();
    }
  }
}
