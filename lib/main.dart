import 'package:flutter/material.dart';
import 'package:social_app/views/screen/auth/Login.dart';
import 'package:social_app/views/screen/auth/forgot_password.dart';
import 'package:social_app/views/screen/chat_info.dart';
import 'package:social_app/views/screen/user_profile.dart';
import 'package:social_app/views/widgets/MainScreen.dart';
import 'package:social_app/views/screen/chat_info.dart';
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
