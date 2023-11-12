import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        children: <Widget>[
          // Phần tiêu đề thông tin tài khoản
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/profile_image.jpg'), // Thay đổi ảnh đại diện
                ),
                SizedBox(height: 10.0),
                Text(
                  'Tên Người Dùng', // Thay đổi tên người dùng
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Email: user@example.com', // Thay đổi email người dùng
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          // Các mục khác về tài khoản cá nhân
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Chỉnh sửa thông tin cá nhân'),
            onTap: () {
              // Xử lý khi người dùng nhấn vào chỉnh sửa thông tin cá nhân
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Đổi mật khẩu'),
            onTap: () {
              // Xử lý khi người dùng nhấn vào đổi mật khẩu
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Đăng xuất'),
            onTap: () {
              // Xử lý khi người dùng nhấn vào đăng xuất
            },
          ),
          // Thêm các mục khác về tài khoản cá nhân nếu cần
        ],
      ),
    );
  }
}
