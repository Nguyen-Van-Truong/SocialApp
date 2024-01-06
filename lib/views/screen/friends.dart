import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../config.dart';
import 'chat_info.dart';
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
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  void _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    _refreshAll();
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      _fetchFriends(),
      _fetchSuggestedFriends(),
      _fetchIncomingRequests(),
      _fetchOutgoingRequests(),
    ]);
  }

  Future<void> _fetchFriends() async {
    int userId = prefs.getInt('user_id') ?? 0;
    var response = await http.get(Uri.parse(
        '${Config.BASE_URL}/api/friendships/getFriendsList.php?userId=$userId'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        setState(() =>
            myFriendList = List<Map<String, dynamic>>.from(data['friends']));
      }
    }
  }

  Future<void> _fetchSuggestedFriends() async {
    int userId = prefs.getInt('user_id') ?? 0;
    var response = await http.get(Uri.parse(
        '${Config.BASE_URL}/api/friendships/getSuggestedFriends.php?userId=$userId'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        setState(() => suggestedFriendList =
            List<Map<String, dynamic>>.from(data['suggested_friends']));
      }
    }
  }

  Future<void> _fetchIncomingRequests() async {
    int userId = prefs.getInt('user_id') ?? 0;
    var response = await http.get(Uri.parse(
        '${Config.BASE_URL}/api/friendships/getIncomingFriendRequests.php?userId=$userId'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        setState(() => incomingRequests =
            List<Map<String, dynamic>>.from(data['incoming_requests']));
      }
    }
  }

  Future<void> _fetchOutgoingRequests() async {
    int userId = prefs.getInt('user_id') ?? 0;
    var response = await http.get(Uri.parse(
        '${Config.BASE_URL}/api/friendships/getOutgoingFriendRequests.php?userId=$userId'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        setState(() => outgoingRequests =
            List<Map<String, dynamic>>.from(data['outgoing_requests']));
      }
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
            RefreshIndicator(
              onRefresh: _refreshAll,
              child: FriendList(
                friendList: myFriendList,
                showAddFriendIcon: false,
                onRefresh: _refreshAll,
                prefs: prefs, // pass SharedPreferences instance
              ),
            ),
            RefreshIndicator(
              onRefresh: _refreshAll,
              child: FriendList(
                friendList: suggestedFriendList,
                showAddFriendIcon: true,
                onRefresh: _refreshAll,
                prefs: prefs,
              ),
            ),
            RefreshIndicator(
              onRefresh: _refreshAll,
              child: FriendList(
                friendList: incomingRequests,
                showAddFriendIcon: false,
                onRefresh: _refreshAll,
                prefs: prefs,
                isIncomingRequest: true, // Indicate it's incoming request tab
              ),
            ),
            RefreshIndicator(
              onRefresh: _refreshAll,
              child: FriendList(
                friendList: outgoingRequests,
                showAddFriendIcon: false,
                onRefresh: _refreshAll,
                prefs: prefs,
                isOutgoingRequest: true, // Indicate it's outgoing request tab
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  final List<Map<String, dynamic>> friendList;
  final bool showAddFriendIcon;
  final Future<void> Function() onRefresh;
  final SharedPreferences prefs;
  final bool isIncomingRequest;
  final bool isOutgoingRequest;

  FriendList({
    Key? key,
    required this.friendList,
    required this.showAddFriendIcon,
    required this.onRefresh,
    required this.prefs,
    this.isIncomingRequest = false,
    this.isOutgoingRequest = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: friendList.length,
        itemBuilder: (context, index) {
          final friend = friendList[index];
          String imageUrl = friend['profile_image_url'] ??
              'assets/images/user_placeholder.png';

          ImageProvider<Object> imageProvider;
          if (imageUrl.startsWith('http') || imageUrl.startsWith('uploads')) {
            imageUrl = imageUrl.startsWith('http')
                ? imageUrl
                : "${Config.BASE_URL}/$imageUrl";
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
                  builder: (context) =>
                      FriendProfile(userId: friend['user_id']),
                ),
              );
            },
            trailing: _buildTrailingIcons(context, friend),
          );
        },
      ),
    );
  }

  Widget _buildTrailingIcons(
      BuildContext context, Map<String, dynamic> friend) {
    if (isIncomingRequest) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => _acceptFriendRequest(context, friend['user_id']),
          ),
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () =>
                _cancelOrRejectFriendRequest(context, friend['user_id']),
          ),
        ],
      );
    } else if (isOutgoingRequest) {
      return IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () =>
            _cancelOrRejectFriendRequest(context, friend['user_id']),
      );
    } else if (showAddFriendIcon) {
      return IconButton(
        icon: Icon(Icons.person_add),
        onPressed: () => _sendFriendRequest(
            context, prefs.getInt('user_id') ?? 0, friend['user_id']),
      );
    } else {
      return IconButton(
        icon: Icon(Icons.message),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatInfo(receiverId: friend['user_id'].toString()),
            ),
          );
        },
      );
    }
  }

  Future<void> _sendFriendRequest(
      BuildContext context, int senderId, int receiverId) async {
    var url =
        Uri.parse('${Config.BASE_URL}/api/friendships/sendFriendRequest.php');
    var response = await http.post(url, body: {
      'requestSender': senderId.toString(),
      'requestReceiver': receiverId.toString(),
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonData['success']
              ? 'Friend request sent successfully'
              : 'Failed to send friend request')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error connecting to server')));
    }
  }

  Future<void> _acceptFriendRequest(BuildContext context, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentUser = prefs.getInt('user_id') ?? 0;

    var url = Uri.parse('${Config.BASE_URL}/api/friendships/acceptFriendRequest.php');
    var response = await http.post(url, body: {
      'currentUser': currentUser.toString(),
      'requestSender': userId.toString(),
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Friend request accepted successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to accept friend request')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error connecting to server')));
    }
  }

  Future<void> _cancelOrRejectFriendRequest(BuildContext context, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int requestingUserId = prefs.getInt('user_id') ?? 0;

    var url = Uri.parse('${Config.BASE_URL}/api/friendships/cancelOrRejectFriendRequest.php');
    var response = await http.post(url, body: {
      'userId': requestingUserId.toString(),
      'otherUserId': userId.toString(),
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Friend request cancelled/rejected successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to cancel/reject friend request')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error connecting to server')));
    }
  }

  Future<void> _unfriend(BuildContext context, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int requestingUserId = prefs.getInt('user_id') ?? 0;

    var url = Uri.parse('${Config.BASE_URL}/api/friendships/unfriend.php');
    var response = await http.post(url, body: {
      'requestingUserId': requestingUserId.toString(),
      'targetUserId': userId.toString(),
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unfriended successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to unfriend')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error connecting to server')));
    }
  }

}
