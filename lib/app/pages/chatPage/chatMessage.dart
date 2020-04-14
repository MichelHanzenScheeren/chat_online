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
        widthFactor: 0.85,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              mine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            mine
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(mensagem["senderPhotoUrl"]),
                    ),
                  ),
            mensagem["imgUrl"] != null
                ? Expanded(
                    child: message(),
                  )
                : mensagem["text"].length < 20
                    ? message()
                    : Expanded(
                        child: message(),
                      ),
            mine
                ? Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(mensagem["senderPhotoUrl"]),
                    ),
                  )
                : Container(),
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
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
            alignment: mine ? Alignment.bottomLeft : Alignment.bottomRight,
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              mensagem["senderName"],
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
