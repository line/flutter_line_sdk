import 'package:flutter/material.dart';

import 'screen/api_page.dart';
import 'screen/home_page.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
        indicatorColor: Colors.white,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('LINE SDK'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'User'),
                Tab(text: 'API'),
              ],
              indicatorColor: null,
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: HomePage(),
              ),
              Center(
                child: APIPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
