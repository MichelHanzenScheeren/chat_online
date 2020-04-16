import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  final Function({String text, File file}) sendMessage;
  TextComposer(this.sendMessage);

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _haveText = false;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        color: Colors.deepPurple,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            alignment: Alignment.bottomCenter,
            icon: Icon(Icons.photo_camera),
            onPressed: _getFile,
          ),
          Expanded(
            child: TextField(
              /*expands: true,
              maxLines: null,
              minLines: null,*/
              controller: _controller,
              decoration: InputDecoration(
                  hintText: "Enviar uma Mensagem",
                  hintStyle: TextStyle(fontSize: 15)),
              style: TextStyle(color: Colors.white, fontSize: 15),
              onChanged: (text) {
                setState(() => _haveText = text.isNotEmpty);
              },
              onSubmitted: (text) {
                if (text.isNotEmpty) {
                  _configureMessage();
                }
              },
            ),
          ),
          IconButton(
            alignment: Alignment.bottomCenter,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _haveText ? _configureMessage : null,
          )
        ],
      ),
    );
  }

  void _configureMessage() {
    widget.sendMessage(text: _controller.text);
    _controller.clear();
    setState(() {
      _haveText = false;
    });
  }

  void _getFile() async {
    final File imgFile =
        await ImagePicker.pickImage(source: ImageSource.camera);
    if (imgFile == null) {
      return;
    } else {
      widget.sendMessage(file: imgFile);
    }
  }
}
