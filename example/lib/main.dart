import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

import 'src/app.dart';

void main() async {
  await LineSDK.instance.setup("1607011670");
  runApp(App());
}
