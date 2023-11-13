import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notificationList.length,
        itemBuilder: (context, index) {
          final notification = notificationList[index];
          return NotificationCard(notification: notification);
        },
      ),
    );
  }
}

final List<NotificationItem> notificationList = [
  NotificationItem(
    avatar: 'assets/images/naruto.jpg',
    title: 'Bryant Marley',
    message: 'mentioned you in a post',
    time: '40m',
  ),
  NotificationItem(
    avatar: 'assets/images/naruto.jpg',
    title: 'Rosalva Sadberry',
    message: 'reacted to your comment',
    time: '33m',
  ),
  // Thêm các thông báo khác nếu cần
];

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
  final NotificationItem notification;

  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(notification.avatar),
        ),
        title: RichText(
          text: TextSpan(
            text: notification.title,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' ${notification.message}',
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
          notification.time,
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
