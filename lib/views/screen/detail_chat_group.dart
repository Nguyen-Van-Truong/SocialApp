import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../config.dart';
class DetailChatGroup extends StatefulWidget {
  final String groupId;

  DetailChatGroup({required this.groupId});

  @override
  _DetailChatGroupState createState() => _DetailChatGroupState();


}
class _DetailChatGroupState extends State<DetailChatGroup> {
  var file_url = "";
  var name = "";
  @override
  void initState() {
    super.initState();
    fetchGroups();
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
              // Xử lý khi lựa chọn từ dropdown menu
              print('Lựa chọn: $choice');
              // Thêm logic xử lý cho từng lựa chọn nếu cần
            },
            itemBuilder: (BuildContext context) {
              return ['Xóa cuộc trò chuyện', 'Cập nhật ảnh nhóm']
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
          Divider(),
          // Các thông tin khác có thể thêm vào đây
        ],
      ),
    );
  }
}
