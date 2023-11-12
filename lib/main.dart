import 'package:flutter/material.dart';
import 'package:social_app/views/screen/auth/Login.dart';
import 'package:social_app/views/widgets/MainScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialApp',
      home: Login(),
    );
  }
}
