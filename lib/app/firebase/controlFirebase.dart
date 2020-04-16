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
  FirebaseUser currentUser;

  bool isLogged() {
    return (FirebaseAuth.instance.currentUser()) != null;
  }

  Future<FirebaseUser> getUser() async {
    if (currentUser != null) {
      return currentUser;
    }

    try {
      await login();
      return currentUser;
    } catch (erro) {
      return null;
    }
  }

  Future login() async {
    final GoogleSignInAccount account = await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication =
        await account.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );
    AuthResult result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    await saveUser(result.user);
  }

  Future saveUser(FirebaseUser user) async {
    Map<String, dynamic> data = {
      "uid": user.uid,
      "name": user.displayName,
      "senderPhotoUrl": user.photoUrl,
      "email": user.email,
      "phone": user.phoneNumber
    };
    await Firestore.instance
        .collection("users")
        .document(data["uid"])
        .setData(data);
  }

  Future sendMessage({String text, File file}) async {
    final FirebaseUser user = await getUser();
    if (user == null) {
      throw Error();
    }

    Map<String, dynamic> data = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoUrl,
      "time": Timestamp.now()
    };

    if (file != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child('images')
          .child(currentUser.uid)
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
    return Firestore.instance
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future<QuerySnapshot> getAllFriends() async {
    return await Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .collection("friends")
        .getDocuments();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    googleSignIn.signOut();
    currentUser = null;
  }
}
