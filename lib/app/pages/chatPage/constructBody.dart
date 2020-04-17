import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:chatonline/app/pages/chatPage/chatMessage.dart';
import 'package:chatonline/app/widgets/waitingWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConstructBody extends StatefulWidget {
  final String uidFriend;
  ConstructBody(this.uidFriend);

  @override
  _ConstructBodyState createState() => _ConstructBodyState();
}

class _ConstructBodyState extends State<ConstructBody> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: ControlFirebase.instance.getMessages(widget.uidFriend),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: WaitingWidget(100, 100));
              break;
            default:
              return _listWidget(snapshot.data.documents.reversed.toList());
          }
        },
      ),
    );
  }

  Widget _listWidget(List<DocumentSnapshot> documents) {
    return ListView.builder(
      itemCount: documents.length,
      reverse: true,
      itemBuilder: (context, index) {
        return ChatMessage(
            documents[index].data,
            documents[index].data["senderUid"] ==
                    ControlFirebase.instance.currentUser?.uid
                ? true
                : false);
      },
    );
  }
}
