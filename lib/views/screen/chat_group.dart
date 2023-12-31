import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:social_app/views/screen/detail_chat_group.dart';
import 'dart:io';
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
  final String profileImageSender;
  final String fileUrl;
  Message(this.text, this.isMe, this.profileImageSender, this.fileUrl);
}

class _ChatGroupState extends State<ChatGroup> {
  List<Message> _messages = [];
  ScrollController _scrollController = ScrollController();
  var imageGroup = "";
  var nameGroup = "";
  String imageSend = "";
  @override
  void initState() {
    super.initState();
    fetchMessages();
    fetchGroups();
    Future.delayed(Duration(milliseconds: 200), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }
  Future<void> fetchGroups() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('user_id') ?? 0;
      // int userId = 1;
      final response = await http.get(
          Uri.parse('${Config.BASE_URL}/api/group_messages/getGroupInfo.php?groupId='+widget.groupId.toString()));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        for (var groupData in jsonData['groups_info']) {
          imageGroup = groupData["file_url"] ?? "null";
          nameGroup = groupData["name"] ?? "";
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
            _messages.add(Message(messageData['message'].toString(), true,messageData['file_url'].toString() ?? "null", messageData['image'].toString() ?? "null"));
          }
          if (messageData['sender_id'].toString() != userId.toString()) {
            _messages.add(Message(messageData['message'].toString(), false, messageData['file_url'].toString() ?? "null", messageData['image'].toString() ?? "null"));
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
        _messages.add(Message(text, true, "null", "null"));
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
                _messages.add(Message("", true, "null",imageSend));
                _textController.clear();
              });
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
          'POST', Uri.parse('${Config.BASE_URL}/api/group_messages/sendImage.php'));
      request.fields['senderId'] = userId.toString();
      request.fields['groupId'] = widget.groupId.toString();
      request.fields['message'] = "Đã gửi 1 ảnh";

      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('media', imageFile.path));
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      setState(() {

      });
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['success']) {
          imageSend = jsonData['message'];
          setState(() {

          });
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
        title: Text(nameGroup),
        actions: [
          CircleAvatar(
            backgroundImage: imageGroup!="null" ? NetworkImage("${Config.BASE_URL}" +"/"+ imageGroup!) : NetworkImage("${Config.BASE_URL}" +"/uploads/1_1702953146.jpg"),
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
                return message.fileUrl == "null" ?  ListTile(
                  title: message.isMe
                      ? Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF105893),
                        borderRadius: BorderRadius.circular(8.0),  // Độ cong của border
                        border: Border.all(
                          color: Color(0xFF105893),
                          width: 1.0,  // Độ dày của border
                        ),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(color: Colors.white),  // Màu chữ trắng để nổi bật trên nền đỏ
                      ),
                        ))
                      : Align(
                          alignment: Alignment.centerLeft,
                         child: Container(
                        padding: EdgeInsets.all(8.0), // Padding để tạo khoảng trắng giữa border và text
                        decoration: BoxDecoration(
                          color: Color(0xFF807F7E),  // Màu nền đỏ
                          borderRadius: BorderRadius.circular(8.0),  // Độ cong của border
                          border: Border.all(
                            color: Color(0xFF807F7E),  // Màu của border
                            width: 1.0,  // Độ dày của border
                          ),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(color: Colors.white),  // Màu chữ trắng để nổi bật trên nền đỏ
                        ),
                      )
                        ),
                  leading: message.isMe
                      ? null  // Không hiển thị ảnh nếu là người gửi
                      : CircleAvatar(
                    backgroundImage: message.profileImageSender !="null" ? NetworkImage("${Config.BASE_URL}" +"/"+ message.profileImageSender) : NetworkImage("${Config.BASE_URL}" +"/uploads/1_1702953146.jpg"),
                  ),
                  subtitle: message.isMe
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Text('Bạn'),
                        )
                      : null,
                ) : Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      "${Config.BASE_URL}" +"/"+message.fileUrl,
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
