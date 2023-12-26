import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:social_app/views/screen/detail_chat_group.dart';

import '../../config.dart';

class ChatGroup extends StatefulWidget {
  final String groupId;

  ChatGroup({required this.groupId});

  @override
  _ChatGroupState createState() => _ChatGroupState();
}

class Message {
  final String text;
  final bool isMe; // Đánh dấu xem tin nhắn có phải của bạn không

  Message(this.text, this.isMe);
}

class _ChatGroupState extends State<ChatGroup> {
  List<Message> _messages = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMessages();

    Future.delayed(Duration(milliseconds: 200), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  Future<void> fetchMessages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('user_id') ?? 0;
      // int userId = 1;
      var url = Uri.parse(
          '${Config.BASE_URL}/api/group_messages/getGroupMessages.php');

      var response = await http.post(url, body: {
        'userId': userId.toString(),
        'groupId': widget.groupId.toString(),
        'limit': "10",
        'page': "0",
      });
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        for (var messageData in jsonData['messages']) {
          if (messageData['sender_id'].toString() == userId.toString()) {
            _messages.add(Message(messageData['message'].toString(), true));
          }
          if (messageData['sender_id'].toString() != userId.toString()) {
            _messages.add(Message(messageData['message'].toString(), false));
          }
        }
        setState(() {});
      } else {}
    } catch (e) {
    } finally {}
  }

  Future<void> sendMessages(String message) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('user_id') ?? 0;
      // int userId = 1;
      var url = Uri.parse(
          '${Config.BASE_URL}/api/group_messages/sendMessage.php');
      var response = await http.post(url, body: {
        'senderId': userId.toString(),
        'groupId': widget.groupId.toString(),
        'message': message.toString(),
      });
    } catch (e) {
    } finally {}
  }

  final TextEditingController _textController = TextEditingController();

  void _handleSendPressed() {
    final text = _textController.text;
    if (text.isNotEmpty) {
      sendMessages(text);
      setState(() {
        _messages.add(Message(text, true));
        _textController.clear();
      });
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
  void _navigateToDetailChatGroup(BuildContext context, String groupId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailChatGroup(groupId :groupId),
      ),
    );
  }
  void _handleSendImage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cuộc trò chuyện'),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/naruto.jpg'),
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _navigateToDetailChatGroup(context, widget.groupId.toString());
            },
          ),
          // PopupMenuButton<String>(
          //   onSelected: (String choice) {
          //     // Xử lý khi lựa chọn từ dropdown menu
          //     print('Lựa chọn: $choice');
          //     // Thêm logic xử lý cho từng lựa chọn nếu cần
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['Lựa chọn 1', 'Lựa chọn 2', 'Lựa chọn 3']
          //         .map((String choice) {
          //       return PopupMenuItem<String>(
          //         value: choice,
          //         child: Text(choice),
          //       );
          //     }).toList();
          //   },
          // ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: message.isMe
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Text(message.text),
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(message.text),
                        ),
                  subtitle: message.isMe
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Text('Bạn'),
                        )
                      : null,
                );
              },
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.upload_file),
                  onPressed: _handleSendImage,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _handleSendPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
