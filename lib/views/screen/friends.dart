import 'package:flutter/material.dart';

class Friends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: ListView.builder(
        itemCount: friendList.length, // Số lượng bạn bè
        itemBuilder: (context, index) {
          final friend = friendList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(friend.avatar), // Ảnh đại diện của bạn bè
            ),
            title: Text(friend.name), // Tên của bạn bè
            subtitle: Text(friend.status), // Trạng thái của bạn bè
            trailing: Icon(Icons.message), // Icon để bắt đầu trò chuyện
            onTap: () {
              // Xử lý khi người dùng nhấn vào bạn bè
              // Điều hướng hoặc hiển thị thông tin bạn bè
            },
          );
        },
      ),
    );
  }
}

// Mô phỏng danh sách bạn bè
final List<Friend> friendList = [
  Friend(name: 'John Doe', avatar: 'assets/john_avatar.jpg', status: 'Online'),
  Friend(name: 'Alice Smith', avatar: 'assets/alice_avatar.jpg', status: 'Away'),
  // Thêm danh sách bạn bè khác nếu cần
];

// Định nghĩa lớp Friend để lưu trữ thông tin bạn bè
class Friend {
  final String name;
  final String avatar;
  final String status;

  Friend({
    required this.name,
    required this.avatar,
    required this.status,
  });
}
