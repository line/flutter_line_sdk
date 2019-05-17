part of flutter_line_sdk;

class AccessToken {
  AccessToken._(this._data);
  
  final Map<String, dynamic> _data;

  String get value => _data['access_token'];
  num get expiresIn => _data['expires_in'];
  String get idTokenRaw => _data['id_token'];
  List<String> get scopes => _data['scope'].split(" ");
  String get tokenType => _data['token_type'];
}