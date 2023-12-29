import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/config.dart';

import '../screen/auth/Login.dart';

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.teal,
    Color(0xFF00FF00),
    Color(0xFF123456),
    Colors.pink,
    Colors.cyan,
    Color(0xFF654321),
    Colors.indigo,
    Colors.amber,
    Color(0xFFABCDEF),
    Colors.deepPurple,
    Color(0xFFAABBCC),
    Colors.lime,
    Colors.brown,
    Color(0xFF654321),
    Colors.grey,
    Color(0xFF999999),
    Colors.lightGreen,
    Colors.deepOrange,
    // Add more colors as needed
  ];



  Future<void> _updateThemeColor(Color color) async {
    final response = await http.post(
      Uri.parse('${Config.BASE_URL}/api/appsettings/themeColor.php'),
      body: {
        'color': color.value.toString(), // Send color value to your API
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
          Container(
            height: 100,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _colors.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => _updateThemeColor(_colors[index]),
                  child: Container(
                    color: _colors[index],
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('Number of Users'),
            subtitle: Text('1000'), // Replace with dynamic data
          ),
          ListTile(
            leading: Icon(Icons.post_add),
            title: Text('Number of Posts'),
            subtitle: Text('500'), // Replace with dynamic data
          ),
          // Add more statistics as needed
        ],
      ),
    );
  }
}