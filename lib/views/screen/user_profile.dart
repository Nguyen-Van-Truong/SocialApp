import 'package:flutter/material.dart';

import '../../model/user.dart';

class UserProfile extends StatelessWidget {
  // Giả sử có một lớp User để lưu trữ thông tin người dùng
  final User user = User(
    name: "Your Name",
    avatar: "path/to/avatar.jpg",
    status: "Your Status",
    friendCount: 100,
    // Các thuộc tính khác
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Mở trang cài đặt
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Media'),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            CircleAvatar(
              backgroundImage: AssetImage(user.avatar),
              radius: 50.0,
            ),
            SizedBox(height: 8.0),
            Text(user.name, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text(user.status, style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 8.0),
            Text('Friends: ${user.friendCount}', style: TextStyle(fontSize: 16.0)),
            Expanded(
              child: TabBarView(
                children: [
                  // Nội dung cho tab "Posts"
                  Center(child: Text('User posts content goes here')),
                  // Nội dung cho tab "Media"
                  Center(child: Text('User media content goes here')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}