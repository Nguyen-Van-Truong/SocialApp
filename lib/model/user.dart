class User {
  String _name;
  String _avatar;
  String _status;
  int _friendCount;

  User({
    required String name,
    required String avatar,
    required String status,
    required int friendCount,
  }) : _name = name,
        _avatar = avatar,
        _status = status,
        _friendCount = friendCount;

  String get name => _name;
  set name(String newName) {
    _name = newName;
  }

  String get avatar => _avatar;
  set avatar(String newAvatar) {
    _avatar = newAvatar;
  }

  String get status => _status;
  set status(String newStatus) {
    _status = newStatus;
  }

  int get friendCount => _friendCount;
  set friendCount(int newFriendCount) {
    _friendCount = newFriendCount;
  }
}
