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
  List<dynamic> posts = [];
  int currentPage = 0;
  bool isLoading = false;
  final int limit = 2;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts({bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
    }

    if (isLoading) {
      return; // Prevent duplicate calls
    }

    isLoading = true;

    await Future.delayed(Duration(seconds: 1));

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('user_id') ?? 0;
      var url = Uri.parse('${Config.BASE_URL}/api/posts/getFriendPosts.php');
      var response = await http.post(url, body: {
        'userId': userId.toString(),
        'page': currentPage.toString(),
        'limit': limit.toString()
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['success']) {
          List<dynamic> newPosts = jsonData['posts'].map((post) {
            bool isLikedConverted = post['isLiked'] == 1;
            post['isLiked'] = isLikedConverted;
            return post;
          }).toList();

          if (refresh) {
            posts = newPosts;
          } else {
            posts.addAll(newPosts);
          }

          currentPage++;
          setState(() {});
        }
      } else {
        print('Failed to load posts');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> _onRefresh() async {
    await fetchPosts(refresh: true);
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
          itemCount: posts.length + 1,
          itemBuilder: (context, index) {
            if (index < posts.length) {
              var post = posts[index];
              return _buildUserPost(
                  post['username'],
                  post['created_at'],
                  List<String>.from(post['media_urls'].map((item) => item.toString())),
                  post['content'],
                  post['post_id'],
                  post['isLiked'],
                  post['likeCount'],
                  post['commentCount'],
                  post['profile_image_url'] // Add this line to pass the profile image URL
              );

            } else if (!isLoading) {
              fetchPosts(); // Fetch more posts
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SizedBox(); // No more data
            }
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

  Widget _buildUserPost(
      String username,
      String timeAgo,
      List<String> mediaUrls,
      String postText,
      int postId,
      bool isLiked,
      int likeCount,
      int commentCount,
      String? profileImageUrl, // Make this nullable
      ) {
    return Column(
      children: <Widget>[
        _buildPostHeader(username, timeAgo, profileImageUrl), // Handle null
        _buildPostContent(postText),
        _buildPostImages(mediaUrls),
        _buildPostActions(postId, isLiked, likeCount, commentCount),
        Divider(),
      ],
    );
  }


  Widget _buildPostHeader(String username, String timeAgo, String? profileImageUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: (profileImageUrl != null
                ? NetworkImage("${Config.BASE_URL}/$profileImageUrl")
                : AssetImage('assets/images/user_placeholder.png')) as ImageProvider<Object>,
            // Explicitly cast to ImageProvider<Object>
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
        int postIndex = posts.indexWhere((p) => p['post_id'] == postId);
        if (postIndex != -1) {
          setState(() {
            posts[postIndex]['isLiked'] = !isLiked;
            posts[postIndex]['likeCount'] += isLiked ? -1 : 1;
          });
        }
      }
    } else {
      print('Error liking/unliking post');
    }
  }

  // Method to show comments in a dialog
  Future<void> _showCommentsDialog(int postId) async {
    TextEditingController commentController = TextEditingController();
    XFile? selectedImage;
    final ImagePicker picker = ImagePicker();
    List<dynamic> comments = await _fetchComments(postId);

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

  // Method to fetch comments from the server
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
