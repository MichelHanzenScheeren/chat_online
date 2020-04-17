import 'package:chatonline/app/firebase/controlFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  TextEditingController _controller = TextEditingController();
  List<DocumentSnapshot> users = [];

  void buscarUsuario() async {
    if (_controller.text != "") {
      List searchedUsers =
          await ControlFirebase.instance.findUser(_controller.text);
      setState(() {
        users = searchedUsers;
      });
    }
  }

  void saveFriend(Map friend) async {
    await ControlFirebase.instance.saveFriend(friend);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Adicionar Amigo"),
        elevation: 0,
      ),
      backgroundColor: Colors.deepPurpleAccent,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "Email do usuário",
                        hintStyle: TextStyle(fontSize: 15)),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: buscarUsuario,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return itemFromList(users[index].data);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget itemFromList(Map<String, dynamic> friend) {
    return Card(
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12),
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
            ),
            IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () {
                saveFriend(friend);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
