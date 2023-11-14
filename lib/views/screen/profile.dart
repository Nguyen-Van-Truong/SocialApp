import 'package:flutter/material.dart';
import 'package:social_app/model/user.dart';
import 'package:social_app/views/screen/auth/Login.dart';
import 'package:social_app/views/screen/auth/change_password.dart';
import 'package:social_app/views/screen/auth/change_password2.dart';
import 'package:social_app/views/screen/edit_personal_information.dart';
import 'package:social_app/views/screen/user_profile.dart';

class Profile extends StatelessWidget {
  final User user = User(name: 'UserName', avatar: 'assets/images/naruto.jpg', status: '', friendCount: 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        children: <Widget>[
          // Account information header section
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfile()), // Chuyển đến màn hình cá nhân người dùng chính
                    );
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/naruto.jpg'), // Change profile picture
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'User Name', // Change to the user's name
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Email: user@example.com', // Change to the user's email
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          // Other personal account items
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Personal Information'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPersonalInformation(user: user),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePassword2(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
          // Add more personal account items if necessary
        ],
      ),
    );
  }
}
