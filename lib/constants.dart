import 'package:flutter/material.dart';
import 'package:fypapp/size_config.dart';

const kPrimaryColor = Color(0xFFff00ff);
const kPrimaryLightColor = Color(0xFFFFECDF);

const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFFFFF7F4);
const kBackground = Color(0xff24292B);
const kSecondaryBackground = Color(0xff474F51);
const kIconColor = Color(0xffE45E32);

const hTextColor = Color(0xFF535353);
const hTextLightColor = Color(0xFFACACAC);

const kAnimationDuration = Duration(microseconds: 200);

const defaultPadding = 20.0;

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Color(0xFFFFECDF),
  height: 1.5,
);


// Form Error
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kTokenNullError = "Please Enter the token";
const String kEmbedTextNullError = "Please Enter text you want to Embed";
// const String kPhoneNumberNullError = "Please Enter your phone number";
// const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
  EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}