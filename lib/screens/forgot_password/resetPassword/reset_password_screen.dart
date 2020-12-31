import 'package:flutter/material.dart';
import 'package:fypapp/size_config.dart';

import 'components/body.dart';

class ResetPasswordScreen extends StatelessWidget {
  static String routeName = "/passwordReset";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
      ),
      body: Body(),
    );
  }
}