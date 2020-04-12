import 'package:flutter/material.dart';
import 'package:chatonline/app/pages/homePage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Online",
      home: HomePage(),
    );
  }
}
