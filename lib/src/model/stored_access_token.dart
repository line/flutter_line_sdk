part of flutter_line_sdk;

class StoredAccessToken {
  StoredAccessToken._(this._data);
  
  final Map<String, dynamic> _data;

  Map<String, dynamic> get data => _data;

  String get value => _data['access_token'];
  num get expiresIn => _data['expires_in'];
}