import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static final String routeName = "home_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Screen"),
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white));
  }
}
