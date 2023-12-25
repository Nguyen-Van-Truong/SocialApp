import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:social_app/config.dart';

class ChangePassword extends StatefulWidget {
  final String email;

  ChangePassword({Key? key, required this.email}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  Future<void> _updatePassword() async {
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    var response = await http.post(
      Uri.parse('${Config.BASE_URL}/api/users/changePassword.php'),
      body: {
        'email': widget.email,
        'newPassword': _newPasswordController.text,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        // Navigate back to the login screen
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        _showErrorDialog(data['message']);
      }
    } else {
      _showErrorDialog('Network error occurred');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _confirmNewPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Update Password'),
              onPressed: _updatePassword,
            ),
          ],
        ),
      ),
    );
  }
}
