import 'package:flutter/material.dart';
import 'package:fypapp/screens/forgot_password/verifyToken/components/verify_form.dart';
import 'package:fypapp/size_config.dart';
import 'package:fypapp/constants.dart';


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Email Verification",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: kPrimaryLightColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter the token sent\nto the registered email",
                textAlign: TextAlign.center,
              ),
              // buildTimer(),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              VerificationForm(),
            ],
          ),
        ),
      ),
    );
  }

}