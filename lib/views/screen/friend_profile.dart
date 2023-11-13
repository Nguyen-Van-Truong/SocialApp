import 'package:flutter/material.dart';

import 'friends.dart';

class FriendProfile extends StatelessWidget {
  final Friend friend;

  FriendProfile({required this.friend});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Posts'), // Tab "Posts"
              Tab(text: 'Media'), // Tab "Media"
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            CircleAvatar(
              backgroundImage: AssetImage(friend.avatar),
              radius: 50.0,
            ),
            SizedBox(height: 8.0),
            Text(friend.name, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text(friend.status, style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 8.0),
            Text('Friends: ${friend.friendCount}', style: TextStyle(fontSize: 16.0)),
            Expanded(
              child: TabBarView(
                children: [
                  // Nội dung cho tab "Posts"
                  Center(child: Text('Posts content goes here')),
                  // Nội dung cho tab "Media"
                  Center(child: Text('Media content goes here')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}