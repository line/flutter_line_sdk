import 'package:flutter/material.dart';
import 'screen/home_page.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: HomePage(),
        ),
      ),
    );
  }
}