import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
            return _buildUserPost(
              post['user_id'].toString(),
              post['created_at'],
              List<String>.from(
                  post['media_urls'].map((item) => item.toString())),
              post['content'],
              post['post_id'],
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

  Widget _buildUserPost(String name, String timeAgo, List<String> mediaUrls,
      String postText, int postId) {
    return Column(
      children: <Widget>[
        _buildPostHeader(name, timeAgo),
        _buildPostContent(postText),
        _buildPostImages(mediaUrls),
        _buildPostActions(postId),
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
      builder: (_) =>
          Dialog(child: Image.network("${Config.BASE_URL}/" + imageUrl)),
    );
  }

  Widget _buildPostActions(int postId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildActionButton(Icons.thumb_up, 'Like', () {
          /* Handle Like */
        }),
        _buildActionButton(
            Icons.comment, 'Comment', () => _showCommentsDialog(postId)),
        _buildActionButton(Icons.share, 'Share', () {
          /* Handle Share */
        }),
      ],
    );
  }

  Widget _buildActionButton(
      IconData icon, String text, VoidCallback onPressed) {
    return Row(
      children: <Widget>[
        IconButton(icon: Icon(icon), onPressed: onPressed),
        Text(text),
      ],
    );
  }

  // Method to show comments in a dialog
  Future<void> _showCommentsDialog(int postId) async {
    TextEditingController commentController = TextEditingController();
    XFile? selectedImage;
    final ImagePicker picker = ImagePicker();
    List<dynamic> comments = await _fetchComments(postId);

    Future<void> selectImage() async {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          selectedImage = pickedFile;
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Comments'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: commentController,
                      decoration:
                          InputDecoration(hintText: 'Write a comment...'),
                    ),
                    SizedBox(height: 10),
                    if (selectedImage != null)
                      Image.file(File(selectedImage!.path)),
                    ElevatedButton(
                      onPressed: selectImage,
                      child: Text('Select Image'),
                    ),
                    ...comments.map((comment) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(comment['user_id'].toString()),
                            subtitle: Text(comment['comment']),
                          ),
                          if (comment['file_url'] != null)
                            GestureDetector(
                              onTap: () =>
                                  _showFullImage(context, comment['file_url']),
                              child: Image.network(
                                  "${Config.BASE_URL}/" + comment['file_url']),
                            ),
                          SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Post Comment'),
                  onPressed: () async {
                    await _postComment(postId, commentController.text,
                        commentController, selectedImage);
                    var updatedComments = await _fetchComments(postId);
                    setState(() {
                      comments = updatedComments;
                      commentController.clear();
                      selectedImage = null;
                    });
                  },
                ),
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Method to fetch comments from the server
  Future<List<dynamic>> _fetchComments(int postId) async {
    var url = Uri.parse(
        '${Config.BASE_URL}/api/comments/getComments.php?postId=$postId');
    var response = await http.get(url);
    print('${Config.BASE_URL}/api/posts/getComments.php?postId=$postId');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // Print the raw response body

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return jsonData['comments'];
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> _postComment(int postId, String comment,
      TextEditingController commentController, XFile? imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    var request = http.MultipartRequest(
        'POST', Uri.parse('${Config.BASE_URL}/api/comments/postComment.php'));
    request.fields['postId'] = postId.toString();
    request.fields['userId'] = userId.toString();
    request.fields['comment'] = comment;

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('media', imageFile.path));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['success']) {
        print('Comment posted successfully');
      } else {
        print('Failed to post comment: ${jsonData['message']}');
      }
    } else {
      print('Failed to connect to the server');
    }

    commentController.clear();
  }
}
