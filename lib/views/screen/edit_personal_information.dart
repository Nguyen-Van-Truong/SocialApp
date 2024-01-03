import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart'; // Import your config file where BASE_URL is defined

class EditPersonalInformation extends StatefulWidget {
  @override
  _EditPersonalInformationState createState() => _EditPersonalInformationState();
}

class _EditPersonalInformationState extends State<EditPersonalInformation> {
  File? _avatarFile;
  String avatarUrl = 'assets/images/naruto.jpg';
  String username = '';
  String email = '';
  String bio = '';
  bool isEditingUsername = false;
  bool isEditingBio = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    var response = await http.post(
      Uri.parse('${Config.BASE_URL}/api/users/getUserProfile.php'),
      body: {
        'userId': userId.toString(),
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          username = data['data']['user_info']['username'];
          email = data['data']['user_info']['email'];
          bio = data['data']['user_info']['bio'];
          _usernameController.text = username;
          _bioController.text = bio;
          avatarUrl = data['data']['user_info']['profile_image'] != null
              ? '${Config.BASE_URL}/${data['data']['user_info']['profile_image']}'
              : 'assets/images/naruto.jpg';
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _avatarFile = File(image.path);
      });
    }
  }

  Future<void> _saveProfileChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    var request = http.MultipartRequest(
        'POST', Uri.parse('${Config.BASE_URL}/api/users/updateUserProfile.php'));

    request.fields['userId'] = userId.toString();
    request.fields['username'] = _usernameController.text;
    request.fields['bio'] = _bioController.text;

    if (_avatarFile != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_image', _avatarFile!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var decodedResponse = json.decode(responseData);
      if (decodedResponse['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile: ${decodedResponse['message']}')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network error occurred')));
    }
  }

  Widget _editableField(String label, String value, TextEditingController controller, bool isEditing, VoidCallback toggleEdit) {
    return Row(
      children: [
        Expanded(
          child: isEditing
              ? TextField(controller: controller)
              : Text('$label: $value'),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: toggleEdit,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;
    if (_avatarFile != null) {
      backgroundImage = FileImage(_avatarFile!);
    } else if (avatarUrl.startsWith('http')) {
      backgroundImage = NetworkImage(avatarUrl);
    } else {
      backgroundImage = AssetImage(avatarUrl);
    }

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
                  backgroundImage: backgroundImage,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text('Email: $email'), // Non-editable email field
            SizedBox(height: 20.0),
            _editableField('Username', username, _usernameController, isEditingUsername, () {
              setState(() => isEditingUsername = !isEditingUsername);
            }),
            _editableField('Bio', bio, _bioController, isEditingBio, () {
              setState(() => isEditingBio = !isEditingBio);
            }),
            ElevatedButton(
              child: Text('Save Changes'),
              onPressed: _saveProfileChanges,
            ),
          ],
        ),
      ),
    );
  }
}
