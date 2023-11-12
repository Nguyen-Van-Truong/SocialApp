import 'package:flutter/material.dart';

class ChatInfo extends StatefulWidget {
  @override
  _ChatInfoState createState() => _ChatInfoState();
}

class Message {
  final String text;
  final bool isMe; // Đánh dấu xem tin nhắn có phải của bạn không

  Message(this.text, this.isMe);
}

class _ChatInfoState extends State<ChatInfo> {
  List<Message> _messages = [
    Message("Xin chào!", false),
    Message("Chào bạn!", true),
    Message("Có gì mới?", false),
    Message("Không có gì đặc biệt.", true),
  ];

  final TextEditingController _textController = TextEditingController();

  void _handleSendPressed() {
    final text = _textController.text;
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(Message(text, true));
        _textController.clear();
      });
    }
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
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.text),
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
