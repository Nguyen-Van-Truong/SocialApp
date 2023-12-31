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
  List<Map<String, dynamic>> suggestedFriendList = [];
  List<Map<String, dynamic>> incomingRequests = [];
  List<Map<String, dynamic>> outgoingRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchFriends();
    _fetchSuggestedFriends();
    _fetchIncomingRequests();
    _fetchOutgoingRequests();
  }

  Future<void> _fetchFriends() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    var response = await http.get(
      Uri.parse('${Config.BASE_URL}/api/friendships/getFriendsList.php?userId=$userId'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          myFriendList = List<Map<String, dynamic>>.from(data['friends']);
        });
      }
    } else {
      print('Failed to fetch friends');
    }
  }

  Future<void> _fetchSuggestedFriends() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    var response = await http.get(
      Uri.parse('${Config.BASE_URL}/api/friendships/getSuggestedFriends.php?userId=$userId'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          suggestedFriendList = List<Map<String, dynamic>>.from(data['suggested_friends']);
        });
      }
    } else {
      print('Failed to fetch suggested friends');
    }
  }

  Future<void> _fetchIncomingRequests() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    var response = await http.get(
      Uri.parse('${Config.BASE_URL}/api/friendships/getIncomingFriendRequests.php?userId=$userId'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          incomingRequests = List<Map<String, dynamic>>.from(data['incoming_requests']);
        });
      }
    } else {
      print('Failed to fetch incoming friend requests');
    }
  }

  Future<void> _fetchOutgoingRequests() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    var response = await http.get(
      Uri.parse('${Config.BASE_URL}/api/friendships/getOutgoingFriendRequests.php?userId=$userId'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          outgoingRequests = List<Map<String, dynamic>>.from(data['outgoing_requests']);
        });
      }
    } else {
      print('Failed to fetch outgoing friend requests');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Friends'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'My Friends'),
              Tab(text: 'Suggest'),
              Tab(text: 'Incoming Requests'),
              Tab(text: 'Outgoing Requests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FriendList(friendList: myFriendList, showAddFriendIcon: false),
            FriendList(friendList: suggestedFriendList, showAddFriendIcon: true),
            FriendList(friendList: incomingRequests, showAddFriendIcon: false),
            FriendList(friendList: outgoingRequests, showAddFriendIcon: false),
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
          imageUrl = imageUrl.startsWith('http') ? imageUrl : "${Config.BASE_URL}/$imageUrl";
          imageProvider = NetworkImage(imageUrl);
        } else {
          imageProvider = AssetImage(imageUrl);
        }

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: imageProvider,
          ),
          title: Text(friend['username'] ?? 'Unknown Name'),
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
