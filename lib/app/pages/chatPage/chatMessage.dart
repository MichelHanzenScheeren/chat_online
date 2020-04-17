import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> mensagem;
  final bool mine;
  ChatMessage(this.mensagem, this.mine);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: FractionallySizedBox(
        alignment: mine ? Alignment.topRight : Alignment.topLeft,
        widthFactor: 0.78,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              mine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            mensagem["imgUrl"] != null
                ? Expanded(
                    child: message(),
                  )
                : mensagem["text"].length < 20
                    ? message()
                    : Expanded(
                        child: message(),
                      ),
          ],
        ),
      ),
    );
  }

  Widget message() {
    return Container(
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(7),
        color: mine ? Colors.deepPurpleAccent : Colors.purple,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          mensagem["imgUrl"] != null
              ? Image.network(
                  mensagem["imgUrl"],
                )
              : Text(
                  mensagem["text"],
                  style: TextStyle(fontSize: 16.0),
                ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              getDate(),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  String getDate() {
    DateTime data = mensagem["time"].toDate();
    return "${data.hour}:${data.minute}";
  }
}
