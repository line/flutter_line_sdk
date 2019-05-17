part of flutter_line_sdk;

class UserProfile {
  UserProfile._(this._data);

  final Map<String, dynamic> _data;

  String get displayName => _data['displayName'];
  String get userId => _data['userId'];
  String get statusMessage => _data['statusMessage'];
  String get pictureUrl => _data['pictureUrl'];
  String get pictureUrlLarge => _data['pictureUrl'] + '/large';
  String get pictureUrlSmall => _data['pictureUrl'] + '/small';
}