import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ControlFirebase {
  static final ControlFirebase instance = ControlFirebase.internal();

  ControlFirebase.internal();
  factory ControlFirebase() => instance;

  void sendMessage({String text, File file}) async {
    Map<String, dynamic> data = {};

    if (file != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child('images')
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(file);
      StorageTaskSnapshot snapshot = await task.onComplete;
      String url = await snapshot.ref.getDownloadURL();
      data["imgUrl"] = url;
    }

    if (text != null) {
      data["text"] = text;
    }

    Firestore.instance.collection("messages").add(data);
  }

  Stream getMessages() {
    return Firestore.instance.collection("messages").snapshots();
  }
}
