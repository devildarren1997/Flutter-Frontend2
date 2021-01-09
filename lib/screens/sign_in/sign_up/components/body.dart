import 'package:flutter/material.dart';
import 'package:fypapp/size_config.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/screens/sign_in/sign_up/components/sign_up_form.dart';

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
                Text("Register Account", style: headingStyle),
                Text(
                  "Complete your details",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                SignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}