import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'dart:io';
import '../../config.dart';

class ChatInfo extends StatefulWidget {
  final String receiverId;

  ChatInfo({required this.receiverId});

  @override
  _ChatInfoState createState() => _ChatInfoState();
}

class Message {
  final String text;
  final bool isMe;
  final String fileUrl;

  Message(this.text, this.isMe, this.fileUrl);
}

class _ChatInfoState extends State<ChatInfo> {
  List<Message> _messages = [];
  ScrollController _scrollController = ScrollController();
  late IOWebSocketChannel channel; // WebSocket channel
  String username = "";
  String avatar = "null";
  String imageSend = "";

  @override
  void initState() {
    super.initState();
    fetchMessages().then((_) {
      Future.delayed(Duration(milliseconds: 500), _scrollToBottom);
    });
    getInforUser();
    connectWebSocket(); // Connect to WebSocket
  }

  void connectWebSocket() {
    channel = IOWebSocketChannel.connect(Config.WEBSOCKET_URL);

    channel.stream.listen((message) {
      // Decode the incoming message
      var decodedMessage = jsonDecode(message);

      // Check if the notification is for a new message in this chat
      if (decodedMessage['type'] == 'new_message' &&
          decodedMessage['chatType'] == 'private' &&
          decodedMessage['from'].toString() == widget.receiverId) {
        // Fetch new messages to update the chat
        fetchLatestMessages().then((_) {
          Future.delayed(Duration(milliseconds: 500), _scrollToBottom);
        });
      }
    });
  }

  Future<void> fetchLatestMessages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('user_id') ?? 0;

      var url =
          Uri.parse('${Config.BASE_URL}/api/messages/fetchLatestMessage.php');
      var response = await http.post(url, body: {
        'user1': userId.toString(),
        'user2': widget.receiverId.toString(),
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        for (var messageData in jsonData['messages']) {
          bool isMe = messageData['sender_id'].toString() == userId.toString();
          _messages.add(Message(messageData['message'].toString(), isMe,
              messageData['file_url'] ?? "null"));
        }
        setState(() {
        });
      }
    } catch (e) {
      // Handle exception
    }
  }

  @override
  void dispose() {
    channel.sink.close(); // Close WebSocket connection
    super.dispose();
  }

  Future<void> sendWebSocketNotification(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;
    var notification = jsonEncode({
      'senderId': userId.toString(),
      'chatType': 'private',
      'receiverId': widget.receiverId,
      'message': message
    });
    channel.sink.add(notification);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && _messages.isNotEmpty) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }


  Future<void> getInforUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('user_id') ?? 0;
      // int userId = 1;
      final response = await http.get(Uri.parse(
          '${Config.BASE_URL}/api/messages/getInforUser.php?userId=' +
              widget.receiverId.toString()));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        for (var groupData in jsonData['user_info']) {
          username = groupData["username"] ?? "";
          avatar = groupData["file_url"] ?? "null";
        }
        setState(() {});
      } else {}
    } catch (e) {
    } finally {}
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
          if (messageData['sender_id'].toString() == userId.toString()) {
            _messages.add(Message(messageData['message'].toString(), true,
                messageData['file_url'] ?? "null"));
          }
          if (messageData['sender_id'].toString() ==
              widget.receiverId.toString()) {
            _messages.add(Message(messageData['message'].toString(), false,
                messageData['file_url'] ?? "null"));
          }
        }
        setState(() {
        });
      } else {}
    } catch (e) {
    } finally {}
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

      // After sending message, send a WebSocket notification
      sendWebSocketNotification(message);
    } catch (e) {
    } finally {}
  }

  final TextEditingController _textController = TextEditingController();

  void _handleSendPressed() {
    final text = _textController.text;
    if (text.isNotEmpty) {
      sendMessages(text);
      setState(() {
        _messages.add(Message(text, true, "null"));
        _textController.clear();
      });
      // Scroll to bottom after a short delay
      Future.delayed(Duration(milliseconds: 500), _scrollToBottom);
    }
  }


  void _upImageChat() {}

  Future<void> _showSendImageDialog() async {
    XFile? selectedImage;
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter dialogSetState) {
            Future<void> selectImage() async {
              final XFile? pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                dialogSetState(() {
                  selectedImage = pickedFile;
                });
              }
            }

            Future<void> handleUpdateImage() async {
              await sendImage(selectedImage);
              dialogSetState(() {
                selectedImage = null;
              });
              setState(() {
                _messages.add(Message("", true, imageSend));
                _textController.clear();
              });
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            }

            return AlertDialog(
              title: Text('Send Image'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.file(File(selectedImage!.path),
                            height: 100, width: 100),
                      ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: selectImage,
                      child: Text('Select Image'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Send'),
                  onPressed: () {
                    handleUpdateImage();

                    Navigator.of(context).pop();
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

  Future<void> sendImage(XFile? imageFile) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('user_id') ?? 0;

      var request = http.MultipartRequest(
          'POST', Uri.parse('${Config.BASE_URL}/api/messages/sendImage.php'));
      request.fields['senderId'] = userId.toString();
      request.fields['receiverId'] = widget.receiverId.toString();
      request.fields['message'] = "Đã gửi 1 ảnh";

      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('media', imageFile.path));
      }
      print('start send');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      setState(() {});
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['success']) {
          imageSend = jsonData['message'];
          setState(() {});
          print('Image sent successfully' + imageSend);
        } else {
          print('Failed to send image: ${jsonData['message']}');
          imageSend = jsonData['message'];
        }
      } else {
        print('Failed to connect to the server');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handleSendImage() {
    _showSendImageDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        actions: [
          CircleAvatar(
            backgroundImage: avatar != "null"
                ? NetworkImage("${Config.BASE_URL}" + "/" + avatar)
                : NetworkImage(
                    "${Config.BASE_URL}" + "/uploads/1_1702953146.jpg"),
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {},
          ),
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
                return message.fileUrl == "null"
                    ? ListTile(
                        title: message.isMe
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF105893),
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: Color(0xFF105893),
                                      width: 1.0, // Độ dày của border
                                    ),
                                  ),
                                  child: Text(
                                    message.text,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  // Padding để tạo khoảng trắng giữa border và text
                                  decoration: BoxDecoration(
                                    color: Color(0xFF807F7E),
                                    // Màu nền đỏ
                                    borderRadius: BorderRadius.circular(8.0),
                                    // Độ cong của border
                                    border: Border.all(
                                      color:
                                          Color(0xFF807F7E), // Màu của border
                                      width: 1.0, // Độ dày của border
                                    ),
                                  ),
                                  child: Text(
                                    message.text,
                                    style: TextStyle(
                                        color: Colors
                                            .white), // Màu chữ trắng để nổi bật trên nền đỏ
                                  ),
                                )),
                        subtitle: message.isMe
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Text('Bạn'),
                              )
                            : null,
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(
                            "${Config.BASE_URL}" + "/" + message.fileUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
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
