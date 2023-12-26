import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/config.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  List<File> _images = []; // List to store multiple images
  String? _userId;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _contentController.addListener(_updateButtonState);
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
    var uri = Uri.parse('${Config.BASE_URL}/api/posts/createPost.php');
    var request = http.MultipartRequest('POST', uri)
      ..fields['userId'] = _userId ?? '1'
      ..fields['content'] = _contentController.text
      ..fields['visible'] = '1';

    for (var image in _images) {
      request.files.add(await http.MultipartFile.fromPath('image[]', image.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Bài viết đã được đăng');
      _showMessage(context, 'Bài viết đã được đăng', Colors.green);
      setState(() {
        _contentController.text = '';
        _images.clear();
      });
    } else {
      print('Lỗi khi đăng bài viết');
      _showMessage(context, 'Lỗi khi đăng bài viết', Colors.red);
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
        title: Text('Create Post'),
      ),
      body: SingleChildScrollView(
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
              onPressed: _pickImages,
              child: Text('Upload Images'),
            ),
            SizedBox(height: 8),
            Wrap(
              children: _images.map((image) => Image.file(image, width: 100, height: 100)).toList(),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _contentController.text.isNotEmpty || _images.isNotEmpty
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
