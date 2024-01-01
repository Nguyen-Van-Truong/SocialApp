import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}


class NotificationItem {
  final String avatar;
  final String title;
  final String message;
  final String time;

  NotificationItem({
    required this.avatar,
    required this.title,
    required this.message,
    required this.time,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationItem? notification;

  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: notification?.avatar != "null"? NetworkImage("${Config.BASE_URL}/"+notification!.avatar!) : NetworkImage("${Config.BASE_URL}/uploads/1_1702953146.jpg"),
        ),
        title: RichText(
          text: TextSpan(
            text: notification?.title,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' ${notification?.message}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        trailing: Text(
          notification!.time,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        onTap: () {
          // Xử lý khi người dùng nhấn vào thông báo
        },
      ),
    );
  }
}

class _NotificationsState extends State<Notifications> {


  @override
  void initState() {
    super.initState();
    _onRefreshG();
    setState(() {
    });
  }
  Future<List<NotificationItem>> fetchNotis(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;
    // int userId = 1;
    final response = await http.get(Uri.parse(
        '${Config.BASE_URL}/api/notifications/notificationPost.php?userId='+userId.toString()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        List<NotificationItem> friends = [];
        for (var postData in data['noti_post_friend']) {

          friends.add(NotificationItem(avatar: postData['file_url'] ?? "null", title: postData['username'] + ' đã đăng', message: postData['content'], time: ""));
        }
        return friends;
      } else {
        throw Exception('Failed to load friends');
      }
    } else {
      throw Exception('Failed to load friends');
    }
  }

  Future<void> _onRefreshG() async {

    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefreshG(),
        child: FutureBuilder(
          future: fetchNotis(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<NotificationItem>? posts = snapshot.data;
              return ListView.builder(
                itemCount: posts?.length,
                itemBuilder: (context, index) {
                  final notification = posts?[index];
                  return NotificationCard(notification: notification);
                },
              );
            }
          },
        ),
      ),
    );
  }
}