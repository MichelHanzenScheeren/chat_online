import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewChat extends StatefulWidget {
  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  Map<String, dynamic> myFriends;

  @override
  void initState() {
    super.initState();
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
            icon: Icon(Icons.search),
            onPressed: () {},
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
                    return Center(
                      child: CircularProgressIndicator(),
                    );
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
        return itemFromList(documents[index].data, documents[index].documentID);
      },
    );
  }

  Widget itemFromList(Map<String, dynamic> friend, String uid) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, uid);
      },
      child: Card(
        color: Colors.deepPurpleAccent,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
          child: Row(
            children: <Widget>[
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(friend["senderPhotoUrl"]),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
