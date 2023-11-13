import 'package:flutter/material.dart';

import '../../model/user.dart';
import 'friend_profile.dart';

class Friends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Friends'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Suggest'), // Tab gợi ý bạn bè
              Tab(text: 'My Friends'), // Tab bạn bè của tôi
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Nội dung cho tab Gợi ý bạn bè
            FriendList(friendList: suggestedFriendList, showAddFriendIcon: true),
            // Nội dung cho tab Bạn bè của tôi
            FriendList(friendList: myFriendList, showAddFriendIcon: false),
          ],
        ),
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  final List<User> friendList;
  final bool showAddFriendIcon;

  const FriendList({Key? key, required this.friendList, required this.showAddFriendIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friendList.length,
      itemBuilder: (context, index) {
        final friend = friendList[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(friend.avatar),
          ),
          title: Text(friend.name),
          subtitle: Text(friend.status),
          trailing: showAddFriendIcon // Kiểm tra nếu muốn hiển thị biểu tượng "Kết bạn"
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.message),
              SizedBox(width: 8.0), // Khoảng cách giữa biểu tượng "Chat" và "Kết bạn"
              Icon(Icons.person_add), // Biểu tượng "Kết bạn"
            ],
          )
              : Icon(Icons.message), // Nếu không hiển thị biểu tượng "Kết bạn"
          onTap: () {
            _navigateToFriendProfile(context, friend); // Điều hướng đến trang cá nhân của bạn bè

          },
        );
      },
    );
  }

  void _navigateToFriendProfile(BuildContext context, User friend) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FriendProfile(friend: friend),
      ),
    );
  }


}

// Mô phỏng danh sách bạn bè gợi ý
final List<User> suggestedFriendList = [
  User(name: 'Jane Smith', avatar: 'assets/jane_avatar.jpg', status: 'Online', friendCount: 10),
  User(name: 'Bob Johnson', avatar: 'assets/bob_avatar.jpg', status: 'Away', friendCount: 10),
  // Thêm danh sách bạn bè gợi ý khác nếu cần
];

// Mô phỏng danh sách bạn bè của tôi
final List<User> myFriendList = [
  User(name: 'John Doe', avatar: 'assets/john_avatar.jpg', status: 'Online', friendCount: 10),
  User(name: 'Alice Smith', avatar: 'assets/alice_avatar.jpg', status: 'Away', friendCount: 10),
  // Thêm danh sách bạn bè của tôi khác nếu cần
];