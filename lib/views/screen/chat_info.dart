import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
class ChatInfo extends StatefulWidget {
  final String receiverId;
  ChatInfo({required this.receiverId});
  @override
  _ChatInfoState createState() => _ChatInfoState();
}

class Message {
  final String text;
  final bool isMe; // Đánh dấu xem tin nhắn có phải của bạn không

  Message(this.text, this.isMe);
}

class _ChatInfoState extends State<ChatInfo> {
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
      var url = Uri.parse('${Config.BASE_URL}/api/messages/read.php');

      var response = await http.post(url, body: {
        'user1': userId.toString(),
        'user2': widget.receiverId.toString(),
      });
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        for (var messageData in jsonData['messages']) {
          if(messageData['sender_id'].toString()==userId.toString()){
            _messages.add(Message(messageData['message'].toString(), true));
          }
          if(messageData['sender_id'].toString()==widget.receiverId.toString()){
            _messages.add(Message(messageData['message'].toString(), false));
          }
        }
        setState(() {
        });
      } else {
      }
    } catch (e) {

    } finally {

    }
  }
  Future<void> sendMessages(String message) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('user_id') ?? 0;
      // int userId = 1;
      var url = Uri.parse('${Config.BASE_URL}/api/messages/sendMessage.php');

      var response = await http.post(url, body: {
        'senderId': userId.toString(),
        'receiverId': widget.receiverId.toString(),
        'message': message.toString(),
      });

    } catch (e) {

    } finally {

    }
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

  void _handleSendImage() {

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cuộc trò chuyện'),
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
                  title: message.isMe ? Align(
                    alignment: Alignment.centerRight,
                    child: Text(message.text),
                  ) : Align(
                    alignment: Alignment.centerLeft,
                    child: Text(message.text),
                  ),
                  subtitle: message.isMe ? Align(
                    alignment: Alignment.centerRight,
                    child: Text('Bạn'),
                  ) : null,
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
