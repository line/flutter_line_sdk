
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
  StoredAccessToken _accessToken;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
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
      return Text("Login");
    } else {
      return UserInfoWidget(userProfile: _userProfile);
    }
  }
}
