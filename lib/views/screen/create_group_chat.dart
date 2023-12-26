import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/config.dart';

class CreateGroupChat extends StatefulWidget {
  @override
  _CreateGroupChatState createState() => _CreateGroupChatState();
}

class _CreateGroupChatState extends State<CreateGroupChat> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<File> _images = []; // List to store multiple images
  String? _userId;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _contentController.addListener(_updateButtonState);
    _descriptionController.addListener(_updateButtonState);
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id').toString();
    });
  }

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? selectedImages = await _picker.pickMultiImage();

    if (selectedImages != null) {
      setState(() {
        _images.addAll(selectedImages.map((image) => File(image.path)));
      });
    }
  }

  Future<void> _uploadPost() async {
    var uri = Uri.parse('${Config.BASE_URL}/api/group_messages/createGroup.php');
    var request = http.MultipartRequest('POST', uri)
      ..fields['userId'] = _userId ?? '1'
      ..fields['name'] = _contentController.text
      ..fields['description'] = _descriptionController.text;

    for (var image in _images) {
      request.files.add(await http.MultipartFile.fromPath('image[]', image.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Bài viết đã được đăng');
      _showMessage(context, 'Group chat đã tạo thành công', Colors.green);
      setState(() {
        _contentController.text = '';
        _descriptionController.text = '';
        _images.clear();
      });
    } else {
      _showMessage(context, 'Lỗi khi tạo group chat', Colors.red);
    }
  }

  void _showMessage(BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Create Group Chat'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _contentController,
              decoration: InputDecoration(hintText: 'Name'),
              maxLines: 2,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(hintText: 'Description'),
              maxLines: 2,
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Upload Images'),
            ),
            SizedBox(height: 8),
            Wrap(
              children: _images.map((image) => Image.file(image, width: 100, height: 100)).toList(),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _contentController.text.isNotEmpty && _images.isNotEmpty && _descriptionController.text.isNotEmpty
                  ? _uploadPost
                  : null,
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
