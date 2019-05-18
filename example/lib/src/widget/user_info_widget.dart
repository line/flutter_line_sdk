import 'package:flutter/material.dart';

import 'package:flutter_line_sdk/flutter_line_sdk.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    Key key,
    this.userProfile,
  }) : super(key: key);

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.network(
            userProfile.pictureUrl, 
            width: 200, 
            height: 200
          ),
          Text(
            userProfile.displayName, 
            style: TextStyle(fontSize: 25)
          ),
          Text(
            userProfile.statusMessage
          ),
        ],
      )
    );
  }
}