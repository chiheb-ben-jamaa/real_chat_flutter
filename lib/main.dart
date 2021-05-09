import 'package:flutter/material.dart';
import './ChatPage.dart';
import 'ChatPage3.dart';

void main() => runApp(MyMaterial());

class MyMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatPage3(),
    );
  }
}
