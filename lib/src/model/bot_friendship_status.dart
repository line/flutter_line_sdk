part of flutter_line_sdk;

class BotFriendshipStatus {
  BotFriendshipStatus._(this._data);

  final Map<String, dynamic> _data;

  bool get isFriend => _data['friendFlag'];
}