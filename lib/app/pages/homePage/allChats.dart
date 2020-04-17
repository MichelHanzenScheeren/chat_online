import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:chatonline/app/pages/chatPage/chat.dart';
import 'package:chatonline/app/widgets/waitingWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllChats extends StatefulWidget {
  final Function(BuildContext context, dynamic page) openPage;
  AllChats(this.openPage);

  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: ControlFirebase.instance.getChats(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(child: WaitingWidget(100, 100));
                  break;
                default:
                  return listWidget(snapshot.data.documents.toList());
              }
            },
          ),
        ),
      ],
    );
  }

  Widget listWidget(List<DocumentSnapshot> documents) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return itemFromList(context, documents[index].data);
      },
    );
  }

  Widget itemFromList(BuildContext context, Map<String, dynamic> friend) {
    return GestureDetector(
      onTap: () {
        widget.openPage(context, Chat(friend["uid"]));
      },
      child: Card(
        color: Colors.deepPurpleAccent,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(friend["photoUrl"]),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Column(
                    children: <Widget>[
                      Text(
                        friend["name"],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
