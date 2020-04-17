import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:chatonline/app/widgets/waitingWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllChats extends StatefulWidget {
  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  @override
  Widget build(BuildContext context) {
    return Container(
        /*Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: ,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: WaitingWidget(100, 100));
              break;
            default:
              return Container();//_listWidget(snapshot.data.documents.reversed.toList());
          }
        },
      ),*/
        );
  }
}
