part of flutter_line_sdk;

class AccessTokenVerifyResult {
  AccessTokenVerifyResult._(this._data);
  
  final Map<String, dynamic> _data;

  String get clientId => _data['client_id'];
  List<String> get scopes => _data['scope'].split(" ");
  num get expiresIn => _data['expires_in'];
}