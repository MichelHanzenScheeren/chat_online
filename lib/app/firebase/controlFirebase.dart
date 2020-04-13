import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ControlFirebase {
  static final ControlFirebase instance = ControlFirebase.internal();
  ControlFirebase.internal();
  factory ControlFirebase() => instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser _currentUser;

  void initUser() {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      _currentUser = user;
    });
  }

  Future<FirebaseUser> getUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    try {
      return await login();
    } catch (erro) {
      return null;
    }
  }

  Future<FirebaseUser> login() async {
    final GoogleSignInAccount account = await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication =
        await account.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    final AuthResult result =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return result.user;
  }

  void sendMessage({String text, File file}) async {
    final FirebaseUser user = await getUser();
    if (user == null) {
      throw Error();
    }

    Map<String, dynamic> data = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoUrl,
    };

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
