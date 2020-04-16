import 'package:chatonline/app/pages/homePage/home.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Online",
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        disabledColor: Colors.black87,
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
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          elevation: 0,
        ),
      ),
    );
  }
}
