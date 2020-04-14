import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> mensagem;
  final bool mine;
  ChatMessage(this.mensagem, this.mine);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          mine
              ? Container()
              : Container(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(mensagem["senderPhotoUrl"]),
                  ),
                ),
          LimitedBox(
            maxWidth: 245,
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
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    mensagem["senderName"],
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                )
              ],
            ),
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
    );
  }
}
