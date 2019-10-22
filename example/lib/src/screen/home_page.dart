import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

import '../theme.dart';
import '../widget/user_info_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  UserProfile _userProfile;
  StoredAccessToken _accessToken;
  bool _isOnlyWebLogin = false;

  final Set<String> _selectedScopes = Set.from(["profile"]);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    UserProfile userProfile;
    StoredAccessToken accessToken;

    try {
      accessToken = await LineSDK.instance.currentAccessToken;
      if (accessToken != null) {
        userProfile = await LineSDK.instance.getProfile();
      }
    } on PlatformException catch (e) {
      print(e.message);
    }

    if (!mounted) return;

    setState(() {
      _userProfile = userProfile;
      _accessToken = accessToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_userProfile == null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _configCard(),
            Expanded(
                child: Center(
              child: RaisedButton(
                textColor: textColor,
                color: accentColor,
                onPressed: _signIn,
                child: Text('Sign In'),
              ),
            )),
          ],
        ),
      );
    } else {
      return UserInfoWidget(
          userProfile: _userProfile, accessToken: _accessToken, onSignOutPressed: _signOut);
    }
  }

  Widget _configCard() {
    return Card(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Configurations",
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: _scopeListUI(),
          ),
          Row(
            children: <Widget>[
              Checkbox(
                activeColor: accentColor,
                value: _isOnlyWebLogin,
                onChanged: (bool value) {
                  setState(() {
                    _isOnlyWebLogin = !_isOnlyWebLogin;
                  });
                },
              ),
              Text("only Web Login"),
            ],
          ),
        ]),
      );
  }

  Widget _scopeListUI() {
    var widgetList = <Widget>[(Text("Scopes: "))];
    widgetList.addAll(_scopes.map<Widget>((String scope) {
      return Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
        child: ChipTheme(
          data: ChipTheme.of(context).copyWith(brightness: Brightness.dark),
          child: FilterChip(
            label: Text(
              scope,
              style: TextStyle(color: textColor),
            ),
            selectedColor: accentColor,
            selected: _selectedScopes.contains(scope),
            onSelected: (bool value) {
              setState(() {
                (!_selectedScopes.contains(scope))
                    ? _selectedScopes.add(scope)
                    : _selectedScopes.remove(scope);
              });
            },
          ),
        ),
      );
    }).toList());

    return Row(children: widgetList);
  }

  void _signIn() async {
    try {
      /// requestCode is for Android platform only, use another unique value in your application.
      final loginOption = LoginOption(_isOnlyWebLogin, "normal", requestCode: 8192);
      final result = await LineSDK.instance.login(
          scopes: _selectedScopes.toList(),
          option: loginOption);
      final accessToken = await LineSDK.instance.currentAccessToken;

      setState(() {
        _userProfile = result.userProfile;
        _accessToken = accessToken;
      });
    } on PlatformException catch (e) {
      _showDialog(context, e.toString());
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
      print(e.message);
    }
  }

  void _showDialog(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(text),
            actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () { Navigator.of(context).pop(); },
            ),
          ],
          );
        });
  }
}

const List<String> _scopes = <String>[
  "profile",
  "openid",
  "email",
];
