import 'package:flutter/material.dart';
import 'package:six_flutter_project/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static final String routeName = "login_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 250),
            CardContainer(
              child: Text('Hola Login',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold)),
            )
          ]),
        ),
      ),
    );
  }
}
