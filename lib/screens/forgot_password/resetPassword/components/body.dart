import 'package:flutter/material.dart';
import 'package:fypapp/screens/forgot_password/resetPassword/components/reset_password_form.dart';
import 'package:fypapp/size_config.dart';
import 'package:fypapp/constants.dart';


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03), // 3%
                Text("Reset Password", style: headingStyle),
                Text(
                  "Enter your new password",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                ResetPasswordForm(),
                SizedBox(height: getProportionateScreenHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}