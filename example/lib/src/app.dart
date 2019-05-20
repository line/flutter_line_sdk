import 'package:flutter/material.dart';
import 'screen/home_page.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('LINE SDK'),
            bottom: TabBar(
              tabs: [
                Tab(text: "User"),
                Tab(text: "API"),
              ]
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: HomePage()
              ),
              Center(
                child: Text("API"),
              )
            ],
          )
        ),
      )
    );
  }
}