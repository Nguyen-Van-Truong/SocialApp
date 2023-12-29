import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/views/screen/auth/Login.dart';
import 'package:social_app/views/screen/auth/change_password2.dart';
import 'package:social_app/views/screen/edit_personal_information.dart';
import 'package:social_app/views/screen/user_profile.dart';

import '../../config.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = '';
  String email = '';
  String avatarUrl = 'assets/images/naruto.jpg'; // Default avatar URL

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
      avatarUrl = prefs.getString('profile_image_url') ?? 'assets/images/naruto.jpg';
      print(avatarUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfile()),
                    );
                  },
                  child: !avatarUrl.startsWith('assets')
                      ? CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage("${Config.BASE_URL}/$avatarUrl"), // Load from network
                  )
                      : CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(avatarUrl), // Load local asset
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Email: $email',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Personal Information'),
            onTap: () {
              // Navigate to EditPersonalInformation screen
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
            onTap: _logout, // Call the logout function here
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all shared preferences

    // Navigate to Login Screen
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }
}
