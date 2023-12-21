import 'package:flutter/material.dart';
import '../widgets/MainScreen.dart';
import 'CreatePostScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/config.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> posts = []; // List to store post data

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('user_id') ?? 0;
      var url = Uri.parse('${Config.BASE_URL}/api/posts/getFriendPosts.php');
      var response = await http.post(url, body: {'userId': userId.toString()});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['success']) {
          setState(() {
            posts = jsonData['posts'];
          });
        }
      } else {
        print('Failed to load posts');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _onRefresh() async {
    // Implement your logic to fetch new posts
    await fetchPosts();
  }

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
              // Menu button event
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            var post = posts[index];
            List<String> mediaUrls = List<String>.from(
                post['media_urls'].map((item) => item.toString()));
            return _buildUserPost(
              post['user_id'].toString(), // Placeholder for user name
              post['created_at'], // Example: '35 min ago'
              mediaUrls,
              post['content'],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildUserPost(String name, String timeAgo, List<String> mediaUrls, String postText) {
    return Column(
      children: <Widget>[
        _buildPostHeader(name, timeAgo),
        _buildPostContent(postText),
        _buildPostImages(mediaUrls),
        _buildPostActions(),
        Divider(),
      ],
    );
  }

  Widget _buildPostHeader(String name, String timeAgo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/user_placeholder.png'),
          ),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(timeAgo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(String postText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(postText, style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildPostImages(List<String> mediaUrls) {
    if (mediaUrls.isEmpty) return SizedBox.shrink();
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: mediaUrls.length > 1 ? 2 : 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: mediaUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showFullImage(context, mediaUrls[index]),
          child: Image.network("${Config.BASE_URL}/" + mediaUrls[index]),
        );
      },
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(child: Image.network("${Config.BASE_URL}/" + imageUrl)),
    );
  }

  Widget _buildPostActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildActionButton(Icons.thumb_up, 'Like', () {/* Handle Like */}),
        _buildActionButton(Icons.comment, 'Comment', () {/* Handle Comment */}),
        _buildActionButton(Icons.share, 'Share', () {/* Handle Share */}),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String text, VoidCallback onPressed) {
    return Row(
      children: <Widget>[
        IconButton(icon: Icon(icon), onPressed: onPressed),
        Text(text),
      ],
    );
  }


}
