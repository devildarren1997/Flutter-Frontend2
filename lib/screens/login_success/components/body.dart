import 'package:flutter/material.dart';
import 'package:fypapp/size_config.dart';
import 'package:fypapp/components/default_button.dart';
import 'package:fypapp/screens/home/home_screen.dart';

class Body extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Expanded(
          flex: 4,
          child:
            Image.asset(
                  "assets/images/success.png",
                  height: SizeConfig.screenHeight * 0.4, //40%
                ),
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Expanded(
          child:
            Text(
              "Login Success",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(30),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.all(50),
          child:
            SizedBox(
              child: DefaultButton(
                text: "Back to home",
                press: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen()), (route) => false);
                },
              ),
            ),
        ),
        Spacer(),
      ],
    );
  }
}