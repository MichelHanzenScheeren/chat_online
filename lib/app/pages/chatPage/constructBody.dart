import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:chatonline/app/pages/chatPage/chatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConstructBody extends StatefulWidget {
  @override
  _ConstructBodyState createState() => _ConstructBodyState();
}

class _ConstructBodyState extends State<ConstructBody> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: ControlFirebase.instance.getMessages(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return _waitingWidget();
              break;

            default:
              return _listWidget(snapshot.data.documents.reversed.toList());
          }
        },
      ),
    );
  }

  Widget _waitingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _listWidget(List<DocumentSnapshot> documents) {
    return ListView.builder(
      itemCount: documents.length,
      reverse: true,
      itemBuilder: (context, index) {
        return ChatMessage(
            documents[index].data,
            documents[index].data["uid"] ==
                    ControlFirebase.instance.currentUser?.uid
                ? true
                : false);
      },
    );
  }
}
