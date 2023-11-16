import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  File? _image;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id').toString();
    });
  }

  Future<void> _uploadPost() async {
    var uri = Uri.parse('http://192.168.1.4/social_app_webservice/api/posts/createPost.php');
    var request = http.MultipartRequest('POST', uri)
      ..fields['userId'] = _userId ?? '1' // Sử dụng userId từ SharedPreferences
      ..fields['content'] = _contentController.text
      ..fields['visible'] = '1'; // Giả sử rằng mọi bài viết đều là hiển thị

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Bài viết đã được đăng');
      // Xử lý thêm sau khi đăng bài viết thành công
    } else {
      print('Lỗi khi đăng bài viết');
      // Xử lý lỗi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _contentController,
              decoration: InputDecoration(hintText: 'Content'),
              maxLines: 6,
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                if (image != null) {
                  setState(() {
                    _image = File(image.path);
                  });
                }
              },
              child: Text('Upload Image'),
            ),
            SizedBox(height: 8),
            _image != null ? Image.file(_image!) : Container(),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _uploadPost,
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
