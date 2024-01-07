import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart'; // Import your config file where BASE_URL is defined

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name = '';
  String? avatar; // Nullable to handle both asset and network images
  String status = '';
  int friendCount = 0;
  int followerCount = 0;
  List<Map<String, dynamic>> listPost = [];

  int currentPage = 0; // Pagination variables
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  List<Map<String, dynamic>> _loadListPosts(List<dynamic> posts) {
    return posts.map((post) {
      return {
        'username': name, // Use the logged-in user's name
        'created_at': post['created_at'],
        'media_urls': List<String>.from(
            post['media_urls'].map((item) => item.toString())),
        'content': post['content'],
        'post_id': post['post_id'],
        'isLiked': post['isLiked'] == 1, // Convert 1 to true, 0 to false
        'likeCount': post['likeCount'],
        'commentCount': post['commentCount'],
      };
    }).toList();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;
    await _fetchUserProfile(userId);
  }

  Future<void> _fetchUserProfile(int userId, {int page = 0}) async {
    if (isLoadingMore) return; // Prevent multiple simultaneous loads
    isLoadingMore = true;

    var response = await http.post(
      Uri.parse('${Config.BASE_URL}/api/users/getUserProfile.php'),
      body: {
        'userId': userId.toString(),
        'page': page.toString(),
        'limit': '5',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          if (page == 0) {
            // Reset data for the first page
            name = data['data']['user_info']['username'];
            status = data['data']['user_info']['bio'];
            friendCount = data['data']['user_info']['friendCount'];
            followerCount = data['data']['user_info']['followerCount'];
            avatar = data['data']['user_info']['profile_image'] != null &&
                    data['data']['user_info']['profile_image'].isNotEmpty
                ? '${Config.BASE_URL}/${data['data']['user_info']['profile_image']}'
                : 'assets/images/user_placeholder.png';
            listPost = []; // Clear previous data
          }

          // Append new posts
          var newPosts = _loadListPosts(data['data']['posts']);
          listPost.addAll(newPosts);

          currentPage = page; // Update the current page
        });
      }
    } else {
      // Handle network error
    }

    isLoadingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    // Determine the ImageProvider based on the avatar string
    ImageProvider backgroundImage;
    if (avatar != null && avatar!.startsWith('http')) {
      backgroundImage =
          NetworkImage(avatar!); // Use NetworkImage for network URLs
    } else {
      backgroundImage = AssetImage(avatar ??
          'assets/images/user_placeholder.png'); // Use AssetImage for assets
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Open settings page
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Media'),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            CircleAvatar(
              backgroundImage: backgroundImage,
              // Use the determined ImageProvider
              radius: 50.0,
            ),
            SizedBox(height: 8.0),
            Text(name,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text(status, style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 8.0),
            Text('Friends: $friendCount', style: TextStyle(fontSize: 16.0)),
            Text('Followers: $followerCount', style: TextStyle(fontSize: 16.0)),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPostsTab(),
                  Center(child: Text('User media content goes here')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoadingMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          // Fetch next page
          final prefs = SharedPreferences.getInstance();
          prefs.then((prefs) {
            int userId = prefs.getInt('user_id') ?? 0;
            _fetchUserProfile(userId, page: currentPage + 1);
          });
        }
        return true;
      },
      child: ListView.builder(
        itemCount: listPost.length,
        itemBuilder: (context, index) {
          var post = listPost[index];
          return _buildUserPost(
              post['username'],
              post['created_at'],
              List<String>.from(
                  post['media_urls'].map((item) => item.toString())),
              post['content'],
              post['post_id'],
              post['isLiked'],
              post['likeCount'],
              post['commentCount']);
        },
      ),
    );
  }

  Widget _buildUserPost(
    String username,
    String timeAgo,
    List<String> mediaUrls,
    String postText,
    int postId,
    bool isLiked,
    int likeCount,
    int commentCount,
  ) {
    return Column(
      children: <Widget>[
        _buildPostHeader(username, timeAgo, avatar), // Pass the avatar URL
        _buildPostContent(postText),
        _buildPostImages(mediaUrls),
        _buildPostActions(postId, isLiked, likeCount, commentCount),
        Divider(),
      ],
    );
  }

  Widget _buildPostHeader(
      String username, String timeAgo, String? profileImageUrl) {
    ImageProvider backgroundImage;
    if (profileImageUrl != null && profileImageUrl.startsWith('http')) {
      backgroundImage = NetworkImage(profileImageUrl); // Network image
    } else {
      backgroundImage = AssetImage(profileImageUrl ??
          'assets/images/user_placeholder.png'); // Local asset
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: backgroundImage,
            radius: 20.0, // Adjust the radius as needed
          ),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
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
    // Filter out empty or null image URLs
    final filteredMediaUrls =
        mediaUrls.where((url) => url != null && url.isNotEmpty).toList();

    if (filteredMediaUrls.isEmpty) return SizedBox.shrink();
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: filteredMediaUrls.length > 1 ? 2 : 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: filteredMediaUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showFullImage(context, filteredMediaUrls[index]),
          child: Image.network(
              "${Config.BASE_URL}/${filteredMediaUrls[index]}"), // Use NetworkImage for network images
        );
      },
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Image.network(
          "${Config.BASE_URL}/$imageUrl",
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text('Image could not be loaded'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPostActions(
      int postId, bool isLiked, int likeCount, int commentCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                color: isLiked ? Colors.blue : Colors.grey,
              ),
              onPressed: () => _handleLike(postId, isLiked),
            ),
            SizedBox(width: 1),
            Text('$likeCount Likes'),
          ],
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.comment, color: Colors.blue),
              onPressed: () => _showCommentsDialog(postId),
            ),
            SizedBox(width: 1),
            Text('$commentCount Comments'),
          ],
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.share, color: Colors.blue),
              onPressed: () {
                /* Handle Share */
              },
            ),
            SizedBox(width: 1),
            Text('Share'),
          ],
        ),
      ],
    );
  }

  Future<void> _handleLike(int postId, bool isLiked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    String endpoint = isLiked ? 'unlikePost.php' : 'likePost.php';
    var url = Uri.parse('${Config.BASE_URL}/api/likes/$endpoint');

    var response = await http.post(url, body: {
      'userId': userId.toString(),
      'postId': postId.toString(),
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      if (jsonData['success']) {
        // Update the post's like count and isLiked status
        int postIndex = listPost.indexWhere((p) => p['post_id'] == postId);
        if (postIndex != -1) {
          setState(() {
            listPost[postIndex]['isLiked'] = !isLiked;
            listPost[postIndex]['likeCount'] += isLiked ? -1 : 1;
          });
        }
      }
    } else {
      print('Error liking/unliking post');
    }
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
    List comments = await _fetchComments(postId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter dialogSetState) {
            Future<void> selectImage() async {
              final XFile? pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                dialogSetState(() {
                  selectedImage = pickedFile;
                });
              }
            }

            Future<void> handlePostComment() async {
              await _postComment(postId, commentController.text,
                  commentController, selectedImage);
              var updatedComments = await _fetchComments(postId);
              dialogSetState(() {
                comments = updatedComments;
                commentController.clear();
                selectedImage = null;
              });
            }

            return AlertDialog(
              title: Text('Comments'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.file(File(selectedImage!.path),
                            height: 100, width: 100),
                      ),
                    TextField(
                      controller: commentController,
                      decoration:
                          InputDecoration(hintText: 'Write a comment...'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: selectImage,
                      child: Text('Select Image'),
                    ),
                    ...comments.map((comment) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(comment['username']),
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
                  onPressed: handlePostComment,
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

  // // Method to fetch comments from the server
  Future<List<dynamic>> _fetchComments(int postId) async {
    var url = Uri.parse(
        '${Config.BASE_URL}/api/comments/getComments.php?postId=$postId');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return jsonData['comments'];
    } else {
      throw Exception('Failed to load comments');
    }
  }

  // Method to post a comment
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
