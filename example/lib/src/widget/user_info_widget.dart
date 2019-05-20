import 'package:flutter/material.dart';

import 'package:flutter_line_sdk/flutter_line_sdk.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    Key key,
    this.userProfile,
    this.onSignOutPressed
  }) : super(key: key);

  final UserProfile userProfile;
  final Function onSignOutPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 200),
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
          Container(
            child: RaisedButton(
              child: Text("Sign Out"),
              onPressed: onSignOutPressed,
              ),
          )
        ],
      )
    );
  }
}