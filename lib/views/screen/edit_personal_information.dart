import 'dart:io';
import 'package:flutter/material.dart';
import 'package:social_app/model/user.dart';
import 'package:image_picker/image_picker.dart';

class EditPersonalInformation extends StatefulWidget {
  final User user;

  EditPersonalInformation({required this.user});

  @override
  _EditPersonalInformationState createState() =>
      _EditPersonalInformationState();
}

class _EditPersonalInformationState extends State<EditPersonalInformation> {
  File? _avatarFile; // Biến lưu ảnh đã chọn

  @override
  void initState() {
    super.initState();
    if (widget.user.avatar != null && !widget.user.avatar.startsWith('assets/')) {
      _avatarFile =
          File(widget.user.avatar); // Khởi tạo File từ đường dẫn avatar
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _avatarFile = File(image.path); // Cập nhật File avatar
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Avatar path: ${_avatarFile}');
    print('Asset path: assets/images/naruto.jpg');
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Personal Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _avatarFile != null
                      ? FileImage(_avatarFile!) as ImageProvider
                      : AssetImage('assets/images/naruto.jpg'),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              initialValue: widget.user.name,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            // Thêm nút lưu thay đổi
            ElevatedButton(
              child: Text('Save Changes'),
              onPressed: () {
                // Xử lý lưu thay đổi thông tin cá nhân
              },
            ),
          ],
        ),
      ),
    );
  }
}
