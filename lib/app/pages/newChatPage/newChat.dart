import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:chatonline/app/pages/addFriendPage/addFriend.dart';
import 'package:chatonline/app/widgets/waitingWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewChat extends StatefulWidget {
  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  Future openPage(BuildContext context, dynamic page) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Nova Conversa"),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              setState(() {
                openPage(context, AddFriend());
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: ControlFirebase.instance.getAllFriends(),
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
      ),
    );
  }

  Widget listWidget(List<DocumentSnapshot> documents) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return itemFromList(documents[index].data);
      },
    );
  }

  Widget itemFromList(Map<String, dynamic> friend) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, friend["uid"]);
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
