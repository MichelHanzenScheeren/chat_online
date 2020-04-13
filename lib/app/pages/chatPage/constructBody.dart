import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConstructBody extends StatefulWidget {
  final Function _getMessages;

  ConstructBody(this._getMessages);

  @override
  _ConstructBodyState createState() => _ConstructBodyState();
}

class _ConstructBodyState extends State<ConstructBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: widget._getMessages(),
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
        ),
      ],
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
        return ListTile(
          title: Text(documents[index].data["text"]),
        );
      },
    );
  }
}
