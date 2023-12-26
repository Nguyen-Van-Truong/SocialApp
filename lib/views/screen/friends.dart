import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../config.dart';
import 'friend_profile.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  List<Map<String, dynamic>> myFriendList = [];

  @override
  void initState() {
    super.initState();
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    var response = await http.get(
      Uri.parse(
          '${Config.BASE_URL}/api/friendships/getFriendsList.php?userId=$userId'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          myFriendList = List<Map<String, dynamic>>.from(data['friends']);
        });
      }
    } else {
      // Handle network error
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Friends'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'My Friends'),
              Tab(text: 'Suggest'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FriendList(friendList: myFriendList, showAddFriendIcon: false),
            Center(child: Text('Suggested friends content goes here')),
          ],
        ),
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  final List<Map<String, dynamic>> friendList;
  final bool showAddFriendIcon;

  const FriendList({Key? key, required this.friendList, required this.showAddFriendIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friendList.length,
      itemBuilder: (context, index) {
        final friend = friendList[index];
        String imageUrl = friend['profile_image_url'] ?? 'assets/images/user_placeholder.png';

        ImageProvider<Object> imageProvider;
        if (imageUrl.startsWith('http') || imageUrl.startsWith('uploads')) {
          // Handling for network images
          imageUrl = imageUrl.startsWith('http') ? imageUrl : "${Config.BASE_URL}/$imageUrl";
          imageProvider = NetworkImage(imageUrl) as ImageProvider<Object>;
        } else {
          // Handling for asset images
          imageProvider = AssetImage(imageUrl) as ImageProvider<Object>;
        }

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: imageProvider,
          ),
          title: Text(friend['name'] ?? 'Unknown Name'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FriendProfile(userId: friend['user_id']),
              ),
            );
          },
          trailing: showAddFriendIcon
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.message),
              SizedBox(width: 8.0),
              Icon(Icons.person_add),
            ],
          )
              : Icon(Icons.message),
        );
      },
    );
  }
}
