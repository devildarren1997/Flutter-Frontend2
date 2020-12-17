import 'package:flutter/material.dart';
import 'package:fypapp/size_config.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/screens/otp/components/otp_form.dart';


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
                "Please enter the token sent\nto the register email",
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

  // Row buildTimer() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Text("This token will expired in "),
  //       TweenAnimationBuilder(
  //         tween: Tween(begin: 30.0, end: 0.0),
  //         duration: Duration(seconds: 30),
  //         builder: (_, value, child) => Text(
  //           "00:${value.toInt()}",
  //           style: TextStyle(color: kPrimaryColor),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}