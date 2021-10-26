import 'package:flutter/material.dart';
import 'package:six_flutter_project/screens/login_screen.dart';
import 'package:six_flutter_project/screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Producto App',
        debugShowCheckedModeBanner: false,
        initialRoute: LoginScreen.routeName,
        routes: {
          HomeScreen.routeName: (BuildContext context) => HomeScreen(),
          LoginScreen.routeName: (BuildContext context) => LoginScreen(),
        },
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
        ));
  }
}
