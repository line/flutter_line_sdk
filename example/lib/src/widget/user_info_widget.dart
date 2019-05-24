import 'package:flutter/material.dart';

import 'package:flutter_line_sdk/flutter_line_sdk.dart';

import '../theme.dart';

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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          (userProfile.pictureUrl.isNotEmpty) ?
          Image.network(
            userProfile.pictureUrl, 
            width: 200, 
            height: 200
          ) : Icon(Icons.person),
          Text(
            userProfile.displayName, 
            style: Theme.of(context).textTheme.headline
          ),
          Text(
            userProfile.statusMessage
          ),
          Container(
            child: RaisedButton(
              textColor: textColor,
              color: accentColor,
              child: Text("Sign Out"),
              onPressed: onSignOutPressed,
            ),
          )
        ],
      )
    );
  }
}
