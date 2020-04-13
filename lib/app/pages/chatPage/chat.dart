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

  void sendMessage({String text, File file}) {
    try {
      ControlFirebase.instance.sendMessage(text: text, file: file);
    } catch (erro) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Não foi possível concluir o login, tente novamente!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    ControlFirebase.instance.initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Olá!"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          ConstructBody(),
          TextComposer(sendMessage),
        ],
      ),
    );
  }
}
