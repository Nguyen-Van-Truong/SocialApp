import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/views/screen/member_edit.dart';
import 'dart:io';
import '../../config.dart';
import 'chat.dart';
import 'chat_info.dart';
class DetailChatGroup extends StatefulWidget {
  final String groupId;

  DetailChatGroup({required this.groupId});

  @override
  _DetailChatGroupState createState() => _DetailChatGroupState();


}
class _DetailChatGroupState extends State<DetailChatGroup> {
  String? _userId;
  var file_url = "";
  var name = "";
  String roleUserInGroup = "";
  @override
  void initState() {
    super.initState();
    fetchGroups();
    _loadUserId();
    getRoleInGroup();
    setState(() {
    });
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
  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id').toString();
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
          file_url = groupData["file_url"] ?? "null";
          name = groupData["name"] ?? "null";
        }
        setState(() {});
      } else {}
    } catch (e) {
    } finally {}
  }
  Future<void> _showUpdateImageDialog() async {
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
              await _updateImage(selectedImage);
              dialogSetState(() {
                selectedImage = null;
              });
              fetchGroups();
            }
            return AlertDialog(
              title: Text('Update Image'),
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
                  child: Text('Update'),
                  onPressed: () {
                    handleUpdateImage();
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
  void _navigateToMember(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MemberEdit(groupId: widget.groupId.toString()),
      ),
    );
  }
  Future<void> _updateImage(XFile? imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Config.BASE_URL}/api/group_messages/updateImageGroup.php'));
    request.fields['postId'] = widget.groupId.toString();
    request.fields['userId'] = _userId ?? '1' ;
    request.fields['comment'] = "";
    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('media', imageFile.path));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['success']) {
        print('Comment posted successfully');
      } else {
        print('Failed to post comment: ${jsonData['message']}');
      }
    } else {
      print('Failed to connect to the server');
    }
  }
  Future<void> _outGroupDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future<void> removeFriend() async {
          try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            int userId = prefs.getInt('user_id') ?? 0;
            var url = Uri.parse('${Config.BASE_URL}/api/group_messages/removeGroupMember.php');

            var response = await http.post(url, body: {
              'userId': userId.toString(),
              'groupId': widget.groupId.toString(),
            });
            Navigator.of(context).pop();
          } catch (e) {

          } finally {

          }
        }
        return StatefulBuilder(
          builder: (context, StateSetter dialogSetState) {
            return AlertDialog(
              title: Text('Confirm out group'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Out'),
                  onPressed: () {
                    removeFriend();
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
  Future<void> _removeGroup() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future<void> removeFriend() async {
          try {
            var url = Uri.parse('${Config.BASE_URL}/api/group_messages/removeGroup.php');
            var response = await http.post(url, body: {
              'groupId': widget.groupId.toString(),
            });
            Navigator.of(context).pop();
          } catch (e) {

          } finally {

          }
        }
        return StatefulBuilder(
          builder: (context, StateSetter dialogSetState) {
            return AlertDialog(
              title: roleUserInGroup=="admin" ? Text('Confirm remove group') : Text('You are not an admin'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Remove'),
                  onPressed: () {
                    if(roleUserInGroup=="admin"){
                      removeFriend();
                    }
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

    return Scaffold(

      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String choice) {
              if (choice == 'Cập nhật ảnh nhóm') {
                _showUpdateImageDialog();
              }
              if (choice == 'Rời nhóm') {
                _outGroupDialog();
              }
              if (choice == 'Xóa cuộc trò chuyện') {
                 _removeGroup();
              }
            },
            itemBuilder: (BuildContext context) {
              return ['Xóa cuộc trò chuyện', 'Cập nhật ảnh nhóm', 'Rời nhóm']
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: file_url != "null"? NetworkImage("${Config.BASE_URL}/"+file_url!) : NetworkImage("${Config.BASE_URL}/uploads/1_1702953146.jpg"),
                ),
                SizedBox(height: 16),
                Text(
                  name.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              _navigateToMember(context);
            },
          leading: IconButton(
            icon: Icon(Icons.account_box_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('Members'), tileColor: Colors.grey[200], shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          ),

          // Các thông tin khác có thể thêm vào đây
        ],
      ),
    );
  }


}
