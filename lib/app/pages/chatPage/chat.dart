import 'package:flutter/material.dart';
import 'package:chatonline/app/firebase/firebase.dart';
import 'package:chatonline/app/pages/chatPage/textComposer.dart';
import 'package:chatonline/app/pages/chatPage/constructBody.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ControlFirebase controlFb = ControlFirebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá!"),
        centerTitle: true,
      ),
      body: ConstructBody(controlFb.getMessages),
      bottomSheet: TextComposer(controlFb.sendMessage),
    );
  }
}
