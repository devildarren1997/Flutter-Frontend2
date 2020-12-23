import 'package:flutter/material.dart';
import 'package:fypapp/screens/login_success/components/body.dart';
import 'package:fypapp/global.dart' as globals;

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";
  final int jsonUserId;

  const LoginSuccessScreen(this.jsonUserId, {Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {

    globals.userId = jsonUserId;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Body(),
    );
  }
}