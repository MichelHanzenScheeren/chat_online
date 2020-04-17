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

  void initUser(Function verifyLogin) {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      currentUser = user;
      verifyLogin();
    });
  }

  Future<String> login() async {
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
    return result.user.displayName;
  }

  Future saveUser(FirebaseUser user) async {
    Map<String, dynamic> data = {
      "uid": user.uid,
      "name": user.displayName,
      "photoUrl": user.photoUrl,
      "email": user.email,
      "phone": user.phoneNumber
    };
    await Firestore.instance
        .collection("users")
        .document(data["uid"])
        .setData(data);
  }

  Future saveFriend(Map friend) async {
    DocumentSnapshot document = await Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .collection("friends")
        .document(friend["uid"])
        .get();
    if (!document.exists) {
      Map<String, dynamic> data = {
        "uid": friend["uid"],
        "name": friend["name"],
        "photoUrl": friend["photoUrl"],
        "hasChat": false
      };
      await Firestore.instance
          .collection("users")
          .document(currentUser.uid)
          .collection("friends")
          .document(friend["uid"])
          .setData(data);

      data["uid"] = currentUser.uid;
      data["name"] = currentUser.displayName;
      data["photoUrl"] = currentUser.photoUrl;
      data["hasChat"] = false;
      await Firestore.instance
          .collection("users")
          .document(friend["uid"])
          .collection("friends")
          .document(currentUser.uid)
          .setData(data);
    }
  }

  Future sendMessage(String uidFriend, {String text, File file}) async {
    final FirebaseUser user = currentUser;
    if (user == null) {
      throw Error();
    }

    List<String> uids = [uidFriend, currentUser.uid];
    uids.sort();

    Map<String, dynamic> data = {
      "senderUid": user.uid,
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

    Firestore.instance
        .collection("chats")
        .document("${uids[0]}${uids[1]}")
        .collection("messages")
        .add(data);

    createUserChat(uidFriend);
  }

  void createUserChat(String uidFriend) async {
    Map<String, dynamic> data = {
      "hasChat": true,
    };
    await Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .collection("friends")
        .document(uidFriend)
        .updateData(data);

    await Firestore.instance
        .collection("users")
        .document(uidFriend)
        .collection("friends")
        .document(currentUser.uid)
        .updateData(data);
  }

  Stream getMessages(String uidFriend) {
    List<String> uids = [uidFriend, currentUser.uid];
    uids.sort();
    return Firestore.instance
        .collection("chats")
        .document("${uids[0]}${uids[1]}")
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Stream getChats() {
    return Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .collection("friends")
        .where("hasChat", isEqualTo: true)
        .snapshots();
  }

  Future<QuerySnapshot> getAllFriends() async {
    return await Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .collection("friends")
        .getDocuments();
  }

  Future<DocumentSnapshot> getFriend(String uid) async {
    return await Firestore.instance.collection("users").document(uid).get();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    googleSignIn.signOut();
    currentUser = null;
  }

  Future<List> findUser(String text) async {
    QuerySnapshot searchedUsers = await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: text)
        .getDocuments();

    return searchedUsers.documents.toList();
  }
}
