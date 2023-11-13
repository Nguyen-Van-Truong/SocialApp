import 'package:flutter/material.dart';
import 'chat_info.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Số lượng tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chats'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Messages'), // Tab tin nhắn
              Tab(text: 'Groups'), // Tab nhóm
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // More actions
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Nội dung cho tab Messages
            ListView(
              children: <Widget>[
                ChatItem(
                  name: 'Kurt Toms',
                  message: 'Are you angry at something?',
                  time: '34 min ago',
                  messageCount: 4,
                  onTap: () {
                    _navigateToChatInfo(context);
                  },
                ),
                // Có thể thêm nhiều ChatItem khác tại đây
              ],
            ),
            // Nội dung cho tab Groups
            ListView(
              children: <Widget>[
                GroupItem(
                  groupName: 'Flutter Devs',
                  lastMessage: 'We have a meeting tomorrow guys!',
                  time: '1 hr ago',
                  messageCount: 2,
                ),
                // Có thể thêm nhiều GroupItem khác tại đây
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Thêm tin nhắn mới
          },
          child: Icon(Icons.add),
        ),
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

class GroupItem extends StatelessWidget {
  final String groupName;
  final String lastMessage;
  final String time;
  final int messageCount;

  const GroupItem({
    Key? key,
    required this.groupName,
    required this.lastMessage,
    required this.time,
    required this.messageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/group_icon.png'), // Thay thế với icon nhóm của bạn
      ),
      title: Text(groupName),
      subtitle: Text(lastMessage),
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

