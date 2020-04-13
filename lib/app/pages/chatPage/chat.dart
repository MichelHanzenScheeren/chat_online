import 'package:flutter/material.dart';
import 'package:chatonline/app/pages/chatPage/textComposer.dart';
import 'package:chatonline/app/pages/chatPage/constructBody.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá!"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          ConstructBody(),
          TextComposer(),
        ],
      ),
    );
  }
}
