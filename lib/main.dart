import 'package:flutter/material.dart';
import 'package:social_app/theme_api.dart';
import 'package:social_app/views/screen/auth/Login.dart';
import 'package:social_app/views/screen/auth/forgot_password.dart';
import 'package:social_app/views/screen/chat_info.dart';
import 'package:social_app/views/screen/detail_chat_group.dart';
import 'package:social_app/views/screen/user_profile.dart';
import 'package:social_app/views/widgets/MainScreen.dart';
import 'package:social_app/views/screen/chat_info.dart';
import 'package:social_app/utils.dart';

import 'views/admin/AdminDashboardPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Color>(
      future: ThemeApi.fetchThemeColor(),
      builder: (context, snapshot) {
        print("snapshot.data:"+snapshot.data.toString());
        print("Colors.red:"+Colors.red.toString());

        return MaterialApp(
          title: 'SocialApp',
          theme: ThemeData(
            primarySwatch: createMaterialColor(snapshot.data ?? Colors.red),
          ),
          home: Login(),
        );
      },
    );
  }
}
