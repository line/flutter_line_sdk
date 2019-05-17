part of flutter_line_sdk;

class LoginResult {
  LoginResult._(this._data) {
    _accessToken = AccessToken._(_data['accessToken']);
    _userProfile = UserProfile._(_data['userProfile']);
  }

  final Map<String, dynamic> _data;
  
  AccessToken _accessToken;
  UserProfile _userProfile;

  AccessToken get accessToken => _accessToken;
  List<String> get scopes => _data['scope'].split(" ");
  UserProfile get userProfile => _userProfile;
  bool get isFriendshipStatusChanged => _data['friendshipStatusChanged'];
}