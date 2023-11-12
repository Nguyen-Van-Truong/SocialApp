import 'package:flutter/material.dart';
import 'package:social_app/views/widgets/CustomBottomNavBar.dart'; // Đảm bảo đường dẫn đến CustomBottomNavBar đúng

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialApp',
      home: CustomBottomNavBar(), // Sử dụng CustomBottomNavBar như là màn hình chính
      // Cấu hình thêm nếu cần
    );
  }
}
