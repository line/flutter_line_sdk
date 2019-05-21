
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

import '../theme.dart';
import '../widget/user_info_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  UserProfile _userProfile;
  String _accessToken;
  String _logs = "";
  bool _isOnlyWebLogin = false;

  final Set<String> _selectedScopes = Set.from({"profile"});

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    
    UserProfile userProfile;
    String accessToken;

    try {
      final token = await LineSDK.instance.currentAccessToken;
      accessToken = token?.value;
      if (token != null) {
        userProfile = await LineSDK.instance.getProfile();
      }
    } on PlatformException catch (e) {
      print(e.message);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _userProfile = userProfile;
      _accessToken = accessToken;
    });
  }

  @override
  Widget build(BuildContext context) => _containerWidget();

  Widget _containerWidget() {
    if (_userProfile == null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isOnlyWebLogin,
                  onChanged: (bool value) {
                    setState(() {
                      _isOnlyWebLogin = !_isOnlyWebLogin;
                    });
                  },
                ),
                Text("only Web Login")
              ],
            ),
            _scopeListUI(),
            RaisedButton(
              textColor: textColor,
              color: accentColor,
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
            Text(_logs),
          ],
        ),
      );
    } else {
      return UserInfoWidget(
        userProfile: _userProfile, 
        onSignOutPressed: _signOut);
    }
  }

  Widget _scopeListUI() {
    var widgetList = <Widget>[(Text("Scopes: "))];
    widgetList.addAll(
        _scopes.map<Widget>((String scope) {
          return Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: FilterChip(
              label: Text(scope, style: TextStyle(color: textColor),),
              selectedColor: accentColor,
              selected: _selectedScopes.contains(scope),
              onSelected: (bool value) {
                setState(() {
                  (!_selectedScopes.contains(scope)) ?
                  _selectedScopes.add(scope) :
                  _selectedScopes.remove(scope);
                });
              },
            ),
          );
        }).toList()
    );

    return Row(children: widgetList);
  }

  void _signIn() async {
    try {
      final result = await LineSDK.instance.login(
        scopes: _selectedScopes.toList(),
        option: LoginOption(_isOnlyWebLogin, "normal")
      );

      setState(() {
        _userProfile = result.userProfile;
        _accessToken = result.accessToken.value;
      });
    } on PlatformException catch (e) {
      setState(() {
        _logs = e.toString();
      });
    }
  }

  void _signOut() async {
    try {
      await LineSDK.instance.logout();
      setState(() {
        _userProfile = null;
        _accessToken = null;
      });
    } on PlatformException catch (e) {
      
    }
  }
}

const List<String> _scopes = <String>[
  "profile",
  "openid",
  "email",
];
