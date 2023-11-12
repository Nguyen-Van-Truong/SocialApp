import 'package:flutter/material.dart';

import '../widgets/MainScreen.dart';
import 'chat_info.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // More actions
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ChatItem(
            name: 'Kurt Toms',
            message: 'Are you angry at something?',
            time: '34 min ago',
            messageCount: 4,
            onTap: () {
              _navigateToChatInfo(context); // Chuyển đến màn hình ChatInfo
            },
          ),
          ChatItem(
            name: 'Gricelda Barrera',
            message: 'Hey, how are you doing?',
            time: '39 min ago',
            messageCount: 16,
            onTap: () {
              _navigateToChatInfo(context); // Chuyển đến màn hình ChatInfo
            },
          ),
          // Thêm các ChatItem widgets cho mỗi cuộc trò chuyện
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Thêm tin nhắn mới
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToChatInfo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatInfo(),
      ),
    );
  }

}

class ChatItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final int messageCount;
  final VoidCallback onTap; // Thêm thuộc tính onTap

  const ChatItem({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
    required this.messageCount,
    required this.onTap, // Truyền hàm onTap vào
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap, // Gọi hàm onTap khi người dùng bấm vào ListTile
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/naruto.jpg'),
      ),
      title: Text(name),
      subtitle: Text(message),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(time),
          SizedBox(height: 4.0),
          if (messageCount > 0)
            CircleAvatar(
              radius: 12.0,
              backgroundColor: Colors.red,
              child: Text(
                messageCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            ),
        ],
      ),
    );
  }
}
