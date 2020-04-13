import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ControlFirebase {
  void sendMessage({String text, File file}) async {
    if (text != null) {
      Firestore.instance.collection("messages").add({"text": text});
    } else {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child('images')
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(file);
      StorageTaskSnapshot snapshot = await task.onComplete;
      String url = await snapshot.ref.getDownloadURL();
      print(url);
    }
  }
}
