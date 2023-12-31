import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/views/screen/chat_group.dart';
import 'package:social_app/views/screen/create_group_chat.dart';
import '../../config.dart';
import 'chat_info.dart';
import 'package:http/http.dart' as http;

class MemberEdit extends StatefulWidget {
  final String groupId;
  MemberEdit({required this.groupId});
  @override
  _MemberEdit createState() => _MemberEdit();
}

class _MemberEdit extends State<MemberEdit> {
  String roleUserInGroup = "";

  @override
  void initState() {
    super.initState();
    getRoleInGroup();
    setState(() {
    });
  }

  Future<List<FriendItem>> fetchFriends(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;
    final response = await http.get(Uri.parse(
        '${Config.BASE_URL}/api/group_messages/getFriendNotInGroup.php?userId=' +
            userId.toString() +
            '&groupId='+ widget.groupId.toString()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        List<FriendItem> friends = [];
        for (var friendData in data['friends']) {
          friends.add(FriendItem(
            id: friendData['user_id'].toString() ?? "",
            username: friendData['username'].toString() ?? "",
            file_url: friendData['file_url'].toString() ?? "null",
            onTap: () {
              if(roleUserInGroup=="admin"){
                _addFriendIntoGroupDialog(friendData['user_id'].toString());
              }
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
    final response = await http.get(Uri.parse(
        '${Config.BASE_URL}/api/group_messages/GetMember.php?groupId=' +
            widget.groupId.toString()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        List<GroupItem> friends = [];
        for (var friendData in data['friends']) {
          friends.add(GroupItem(
            id: friendData['user_id'].toString() ?? "",
            groupName: friendData['username'] ?? "",
            file_url: friendData['file_url'].toString() ?? "null",
            lastMessage: friendData['role'] ?? "",
            onTap: () {
              if(roleUserInGroup=="admin") {
                _removeFriendIntoGroupDialog(friendData['user_id'].toString());
              }
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

  Future<void> getRoleInGroup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;
    final response = await http.get(Uri.parse(
        '${Config.BASE_URL}/api/group_messages/getRoleInGroup.php?userId=' +
            userId.toString() +
            '&groupId='+ widget.groupId.toString()));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      for (var groupData in jsonData['data']) {
        roleUserInGroup = groupData["role"] ?? "member";
      }
    } else {
      throw Exception('Failed to load friends');
    }
  }
  Future<void> _onRefreshF(BuildContext context) async {
    await fetchFriends(context);
    setState(() {
    });
  }

  Future<void> _onRefreshG(BuildContext context) async {
    await fetchGroups(context);
    setState(() {
    });
  }


  Future<void> _addFriendIntoGroupDialog(String userIdIsAdd) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter dialogSetState) {
            Future<void> addFriend(String userIdIsAdd) async {
              try {
                // int userId = 1;
                var url = Uri.parse('${Config.BASE_URL}/api/group_messages/addGroupMember.php');

                var response = await http.post(url, body: {
                  'userId': userIdIsAdd,
                  'groupId': widget.groupId.toString(),
                });
                Navigator.of(context).pop();
                _onRefreshF(context);
              } catch (e) {

              } finally {

              }
            }
            return AlertDialog(
              title: Text('Confirm add member'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    addFriend(userIdIsAdd);
                  },
                ),
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  Future<void> _removeFriendIntoGroupDialog(String userIdIsAdd) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future<void> removeFriend(String userIdIsAdd) async {
          try {
            // int userId = 1;
            var url = Uri.parse('${Config.BASE_URL}/api/group_messages/removeGroupMember.php');

            var response = await http.post(url, body: {
              'userId': userIdIsAdd,
              'groupId': widget.groupId.toString(),
            });
            Navigator.of(context).pop();
            _onRefreshG(context);
          } catch (e) {

          } finally {

          }
        }
        return StatefulBuilder(
          builder: (context, StateSetter dialogSetState) {
            return AlertDialog(
              title: Text('Confirm remove member'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Remove'),
                  onPressed: () {
                    removeFriend(userIdIsAdd);
                  },
                ),
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Số lượng tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Members'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Add Members'), // Tab tin nhắn
              Tab(text: 'Members'), // Tab nhóm
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
            RefreshIndicator(
              onRefresh: () => _onRefreshF(context),
              child: FutureBuilder(
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
            ),
            // Nội dung cho tab Groups
            RefreshIndicator(
              onRefresh: () => _onRefreshG(context),
              child: FutureBuilder(
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
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChatInfo(BuildContext context, String receiverId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatInfo(receiverId: receiverId),
      ),
    );
  }

  void _navigateToChatGroup(BuildContext context, String groupId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatGroup(groupId: groupId),
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
      onTap: onTap,
      // Gọi hàm onTap khi người dùng bấm vào ListTile
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
  final VoidCallback onTap; // Thêm thuộc tính onTap

  const FriendItem({
    Key? key,
    required this.id,
    required this.username,
    required this.file_url,
    required this.onTap, // Truyền hàm onTap vào
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      // Gọi hàm onTap khi người dùng bấm vào ListTile
      leading: CircleAvatar(
        backgroundImage: file_url != "null"
            ? NetworkImage("${Config.BASE_URL}/" + file_url!)
            : NetworkImage("${Config.BASE_URL}/uploads/1_1702953146.jpg"),
      ),
      title: Text(username),
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
        backgroundImage: file_url != "null"
            ? NetworkImage("${Config.BASE_URL}/" + file_url!)
            : NetworkImage("${Config.BASE_URL}/uploads/1_1702953146.jpg"),
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
