import 'package:flutter/material.dart';
import 'package:chatonline/app/pages/chatPage/chat.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Online",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        disabledColor: Colors.black45,
        primaryColor: Colors.deepPurple,
        hintColor: Colors.white,
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: Chat(),
    );
  }
}
