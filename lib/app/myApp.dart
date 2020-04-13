import 'package:flutter/material.dart';
import 'package:chatonline/app/pages/homePage/home.dart';
import 'package:chatonline/app/pages/chatPage/chat.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Online",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        iconTheme: IconThemeData(
          color: Colors.deepPurple,
        ),
      ),
      home: Chat(),
    );
  }
}
