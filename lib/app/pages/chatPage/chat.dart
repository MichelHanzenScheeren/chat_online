import 'dart:io';

import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:flutter/material.dart';
import 'package:chatonline/app/pages/chatPage/textComposer.dart';
import 'package:chatonline/app/pages/chatPage/constructBody.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoadingImg = false;

  @override
  void initState() {
    super.initState();
    ControlFirebase.instance.initUser();
  }

  Future sendMessage({String text, File file}) async {
    try {
      setLoading(true);
      await ControlFirebase.instance.sendMessage(text: text, file: file);
      setLoading(false);
    } catch (error) {
      showSnackbar(
          "Não foi possível concluir o login, tente novamente!", Colors.red);
    }
  }

  void setLoading(bool loading) {
    setState(() {
      isLoadingImg = loading;
    });
  }

  void showSnackbar(String text, Color cor) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
        backgroundColor: cor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(ControlFirebase.instance.currentUser != null
            ? "Olá, ${ControlFirebase.instance.currentUser.displayName}"
            : "ChatApp"),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          ControlFirebase.instance.currentUser != null
              ? IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    setState(() {
                      ControlFirebase.instance.signOut();
                    });
                    showSnackbar("signOut concluído!", Colors.yellow);
                  },
                )
              : Container()
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "images/background.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              ConstructBody(),
              isLoadingImg ? LinearProgressIndicator() : Container(),
              TextComposer(sendMessage),
            ],
          ),
        ],
      ),
    );
  }
}
