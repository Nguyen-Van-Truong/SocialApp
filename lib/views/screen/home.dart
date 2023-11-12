import 'package:flutter/material.dart';
import '../widgets/CustomBottomNavBar.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feeds'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Xử lý sự kiện khi menu được nhấn
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildUserPost(
                    'Bryant Marley',
                    '35 min ago',
                    'assets/images/naruto.jpg',
                    'This is the text for Bryant Marley\'s post. ', // Example long text
                  ),
                  _buildUserPost(
                    'Kurt Toms',
                    '25 min ago',
                    'assets/images/naruto.jpg',
                    'This is the text for Kurt Toms\' post.',
                  ),
                  _buildUserPost(
                    'Ling Waldner',
                    '37 min ago',
                    'assets/images/naruto.jpg',
                    'This is the text for Ling Waldner\'s post.',
                  ),
                  // Thêm các widget cho người dùng khác nếu cần
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Xử lý sự kiện khi nút thêm mới được nhấn
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildUserPost(String name, String timeAgo, String imagePath, String postText) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage(imagePath),
              ),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(timeAgo),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            postText,
            style: TextStyle(fontSize: 18), // Adjust the font size as needed
          ),
        ),
        Image.asset(imagePath), // Add the post image
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () {
                    // Handle like button press
                  },
                ),
                Text('Like'),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    // Handle comment button press
                  },
                ),
                Text('Comment'),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    // Handle share button press
                  },
                ),
                Text('Share'),
              ],
            ),
          ],
        ),
        Divider(), // Add a divider between posts
      ],
    );
  }
}
