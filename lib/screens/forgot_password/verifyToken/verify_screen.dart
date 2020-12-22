import 'package:flutter/material.dart';
import 'package:fypapp/size_config.dart';

import 'components/body.dart';


class PasswordVerifyScreen extends StatelessWidget {
  static String routeName = "/password_verify";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Email Verification"),
      ),
      body: Body(),
    );
  }
}