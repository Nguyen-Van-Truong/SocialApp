import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notificationList.length, // Số lượng thông báo
        itemBuilder: (context, index) {
          final notification = notificationList[index];
          return ListTile(
            leading: Icon(notification.icon), // Biểu tượng của thông báo
            title: Text(notification.title), // Tiêu đề của thông báo
            subtitle: Text(notification.message), // Nội dung thông báo
            onTap: () {
              // Xử lý khi người dùng nhấn vào thông báo
              // Điều hướng hoặc hiển thị chi tiết thông báo
            },
          );
        },
      ),
    );
  }
}

// Mô phỏng danh sách thông báo
final List<NotificationItem> notificationList = [
  NotificationItem(
    icon: Icons.notifications,
    title: 'Thông báo 1',
    message: 'Nội dung thông báo 1',
  ),
  NotificationItem(
    icon: Icons.notifications,
    title: 'Thông báo 2',
    message: 'Nội dung thông báo 2',
  ),
  // Thêm danh sách thông báo khác nếu cần
];

// Định nghĩa lớp NotificationItem để lưu trữ thông tin thông báo
class NotificationItem {
  final IconData icon;
  final String title;
  final String message;

  NotificationItem({
    required this.icon,
    required this.title,
    required this.message,
  });
}
