
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

import '../widget/user_info_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  UserProfile _userProfile;
  String _accessToken;

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
      return RaisedButton(
          onPressed: _signIn,
          child: Text(
            'Sign In'
          ),
        );
    } else {
      return UserInfoWidget(
        userProfile: _userProfile, 
        onSignOutPressed: _signOut);
    }
  }

  void _signIn() async {
    try {
      final result = await LineSDK.instance.login();
      setState(() {
        _userProfile = result.userProfile;
        _accessToken = result.accessToken.value;
      });
    } on PlatformException catch (e) {
      
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
