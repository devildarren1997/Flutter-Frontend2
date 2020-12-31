
import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/size_config.dart';
import 'package:lottie/lottie.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.lottie,
  }) : super(key: key);
  final String text, lottie;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          "MarkEmb",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: kPrimaryLightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 2),
        Container(
          child: Lottie.asset(lottie),
          height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(235),
        ),
      ],
    );
  }
}