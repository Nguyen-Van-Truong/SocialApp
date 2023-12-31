import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/config.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../screen/auth/Login.dart';

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  Map<String, dynamic> _statistics = {};

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  Future<void> _fetchStatistics() async {
    final response = await http.get(Uri.parse('${Config.BASE_URL}/api/statistics/getStatistics.php'));

    if (response.statusCode == 200) {
      setState(() {
        _statistics = jsonDecode(response.body)['statistics'];
      });
    } else {
      print("Failed to fetch statistics");
    }
  }

  Future<void> _updateThemeColor() async {
    Color pickedColor = Colors.blue; // Default color
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickedColor,
              onColorChanged: (Color color) {
                pickedColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
                _sendColorToApi(pickedColor);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendColorToApi(Color color) async {
    final response = await http.post(
      Uri.parse('${Config.BASE_URL}/api/appsettings/themeColor.php'),
      body: {
        'color': color.value.toString(),
      },
    );

    if (response.statusCode == 200) {
      print("Theme color updated");
    } else {
      print("Failed to update theme color");
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all shared preferences
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Theme Color Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Select Theme Color'),
            onTap: _updateThemeColor,
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Total Number of Users'),
            subtitle: Text('${_statistics['total_users'] ?? 'Loading...'}'),
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Total Users with Role: User'),
            subtitle: Text('${_statistics['total_users_with_role_user'] ?? 'Loading...'}'),
          ),
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text('Total Users with Role: Admin'),
            subtitle: Text('${_statistics['total_users_with_role_admin'] ?? 'Loading...'}'),
          ),
          ListTile(
            leading: Icon(Icons.post_add),
            title: Text('Number of Posts'),
            subtitle: Text('${_statistics['total_posts'] ?? 'Loading...'}'),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Most Active User'),
            subtitle: Text('${_statistics['most_active_user']?['username'] ?? 'Loading...'} - Posts: ${_statistics['most_active_user']?['post_count'] ?? ''}'),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('User with Most Followers'),
            subtitle: Text('${_statistics['most_followed_user']?['username'] ?? 'Loading...'} - Followers: ${_statistics['most_followed_user']?['follower_count'] ?? ''}'),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('User with Most Friends'),
            subtitle: Text('${_statistics['user_with_most_friends']?['username'] ?? 'Loading...'} - Friends: ${_statistics['user_with_most_friends']?['friend_count'] ?? ''}'),
          ),
        ],
      ),
    );
  }
}
