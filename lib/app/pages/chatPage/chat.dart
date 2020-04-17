import 'dart:io';
import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:chatonline/app/widgets/waitingWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatonline/app/pages/chatPage/textComposer.dart';
import 'package:chatonline/app/pages/chatPage/constructBody.dart';

class Chat extends StatefulWidget {
  final String uidFriend;
  Chat(this.uidFriend);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoadingImg = false;
  DocumentSnapshot friend;

  @override
  void initState() {
    super.initState();
    getFriend();
  }

  void getFriend() async {
    DocumentSnapshot document =
        await ControlFirebase.instance.getFriend(widget.uidFriend);
    setState(() {
      friend = document;
    });
  }

  Future sendMessage({String text, File file}) async {
    try {
      setState(() => isLoadingImg = true);
      await ControlFirebase.instance
          .sendMessage(widget.uidFriend, text: text, file: file);
      setState(() => isLoadingImg = false);
    } catch (error) {
      print("Não foi possível enviar a mensagem.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: myTitle(),
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
          buildChat(),
        ],
      ),
    );
  }

  Widget myTitle() {
    if (friend == null) {
      return WaitingWidget(20, 20);
    } else {
      return Row(
        children: <Widget>[
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(friend.data["photoUrl"]),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                children: <Widget>[
                  Text(friend.data["name"]),
                ],
              ),
            ),
          )
        ],
      );
    }
  }

  Widget buildChat() {
    return Column(
      children: <Widget>[
        ConstructBody(widget.uidFriend),
        isLoadingImg ? LinearProgressIndicator() : Container(),
        TextComposer(sendMessage),
      ],
    );
  }
}
