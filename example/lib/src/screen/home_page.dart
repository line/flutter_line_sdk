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
  UserProfile? _userProfile;
  String? _userEmail;
  StoredAccessToken? _accessToken;
  bool _isOnlyWebLogin = false;

  final Set<String> _selectedScopes = Set.from(['profile']);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    UserProfile? userProfile;
    StoredAccessToken? accessToken;

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
                  child: ElevatedButton(
                      child: Text('Sign In'),
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor, foregroundColor: textColor))),
            ),
          ],
        ),
      );
    } else {
      return UserInfoWidget(
        userProfile: _userProfile!,
        userEmail: _userEmail,
        accessToken: _accessToken!,
        onSignOutPressed: _signOut,
      );
    }
  }

  Widget _configCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _scopeListUI(),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  activeColor: accentColor,
                  value: _isOnlyWebLogin,
                  onChanged: (bool? value) {
                    setState(() {
                      _isOnlyWebLogin = !_isOnlyWebLogin;
                    });
                  },
                ),
                Text('only Web Login'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _scopeListUI() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Scopes: '),
          Wrap(
            children:
                _scopes.map<Widget>((scope) => _buildScopeChip(scope)).toList(),
          ),
        ],
      );

  Widget _buildScopeChip(String scope) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ChipTheme(
          data: ChipTheme.of(context).copyWith(brightness: Brightness.dark),
          child: FilterChip(
            label: Text(scope, style: TextStyle(color: textColor)),
            selectedColor: accentColor,
            backgroundColor: secondaryBackgroundColor,
            selected: _selectedScopes.contains(scope),
            onSelected: (_) {
              setState(() {
                _selectedScopes.contains(scope)
                    ? _selectedScopes.remove(scope)
                    : _selectedScopes.add(scope);
              });
            },
          ),
        ),
      );

  void _signIn() async {
    try {
      /// requestCode is for Android platform only, use another unique value in your application.
      final loginOption =
          LoginOption(_isOnlyWebLogin, 'normal', requestCode: 8192);
      final result = await LineSDK.instance
          .login(scopes: _selectedScopes.toList(), option: loginOption);
      final accessToken = await LineSDK.instance.currentAccessToken;

      final userEmail = result.accessToken.email;

      setState(() {
        _userProfile = result.userProfile;
        _userEmail = userEmail;
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
        _userEmail = null;
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
            TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(foregroundColor: accentColor)),
          ],
        );
      },
    );
  }
}

const List<String> _scopes = <String>['profile', 'openid', 'email'];
