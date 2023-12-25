import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/views/screen/chat_group.dart';
import 'chat_info.dart';
import 'package:http/http.dart' as http;
class Chat extends StatelessWidget  {

  Future<List<FriendItem>> fetchFriends(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;
    // int userId = 1;
    final response = await http.get(
        Uri.parse('http://192.168.209.35//social_app_webservice/api/messages/getFriendsListMessage.php?userId='+userId.toString()+'&sortOrder=recent'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        List<FriendItem> friends = [];
        for (var friendData in data['friends']) {
          friends.add(FriendItem(
            id: friendData['user_id'].toString(),
            username: friendData['username'],
            file_url: friendData['file_url'] ?? "null",
            lastMessage: friendData['latest_message'] ,
            onTap: () {
            _navigateToChatInfo(context, friendData['user_id'].toString());
            },
          ));
        }
        return friends;
      } else {
        throw Exception('Failed to load friends');
      }
    } else {
      throw Exception('Failed to load friends');
    }
  }
  Future<List<GroupItem>> fetchGroups(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;
    // int userId = 1;
    final response = await http.get(
        Uri.parse('http://192.168.209.35//social_app_webservice/api/group_messages/getGroupList.php?userId='+userId.toString()+'&sortOrder=recent'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        List<GroupItem> friends = [];
        for (var friendData in data['groups']) {
          friends.add(GroupItem(
            id: friendData['group_id'].toString(),
            groupName: friendData['name'],
            file_url: friendData['file_url'] ?? "null",
            lastMessage: friendData['last_message'],
            onTap: () {
              _navigateToChatGroup(context, friendData['group_id'].toString());
            },
          ));
        }
        return friends;
      } else {
        throw Exception('Failed to load friends');
      }
    } else {
      throw Exception('Failed to load friends');
    }
  }
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
            FutureBuilder(
              future: fetchFriends(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<FriendItem>? friends = snapshot.data;
                  return ListView.builder(
                    itemCount: friends?.length,
                    itemBuilder: (context, index) {
                      return friends?[index];
                    },
                  );
                }
              },
            ),
            // Nội dung cho tab Groups
            FutureBuilder(
              future: fetchGroups(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<GroupItem>? friends = snapshot.data;
                  return ListView.builder(
                    itemCount: friends?.length,
                    itemBuilder: (context, index) {
                      return friends?[index];
                    },
                  );
                }
              },
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

  void _navigateToChatInfo(BuildContext context, String receiverId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatInfo(receiverId :receiverId),
      ),
    );
  }

  void _navigateToChatGroup(BuildContext context, String groupId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatGroup(groupId :groupId),
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

class FriendItem extends StatelessWidget {
  final String id;
  final String username;
  final String file_url;
  final String lastMessage;
  final VoidCallback onTap; // Thêm thuộc tính onTap

  const FriendItem({
    Key? key,
    required this.id,
    required this.username,
    required this.file_url,
    required this.lastMessage,
    required this.onTap, // Truyền hàm onTap vào
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap, // Gọi hàm onTap khi người dùng bấm vào ListTile
      leading: CircleAvatar(
        backgroundImage: file_url != "null"? NetworkImage(file_url!) : NetworkImage("http://192.168.209.35/social_app_webservice/uploads/1_1702953146.jpg"),
      ),
      title: Text(username),
      subtitle: Text(lastMessage),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(""),
          SizedBox(height: 4.0),
        ],
      ),
    );
  }
}

class GroupItem extends StatelessWidget {
  final String id;
  final String groupName;
  final String lastMessage;
  final String file_url;
  final VoidCallback onTap;

  const GroupItem({
    Key? key,
    required this.id,
    required this.groupName,
    required this.lastMessage,
    required this.file_url,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: file_url != "null"? NetworkImage(file_url!) : NetworkImage("http://192.168.209.35/social_app_webservice/uploads/1_1702953146.jpg"),
      ),
      title: Text(groupName),
      subtitle: Text(lastMessage),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(""),
          SizedBox(height: 4.0),
        ],
      ),
    );
  }
}

