


import 'package:flutter/material.dart';
import 'package:fypapp/screens/extract/extractHomeScreen.dart';
import 'package:fypapp/screens/forgot_password/forgot_password_screen.dart';
import 'package:fypapp/screens/forgot_password/verifyToken/verify_screen.dart';
import 'package:fypapp/screens/home/home_screen.dart';
import 'package:fypapp/screens/login_success/login_success_screen.dart';
import 'package:fypapp/screens/otp/otp_screen.dart';
import 'package:fypapp/screens/sign_in/sign_in_screen.dart';
import 'package:fypapp/screens/sign_in/sign_up/sign_up_screen.dart';
import 'package:fypapp/screens/splash/splash_screen.dart';
import 'package:fypapp/screens/uploadImage/uploadScreen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  UploadScreen.routeName: (context) => UploadScreen(),
  ExtractHomeScreen.routeName: (context) => ExtractHomeScreen(),
  PasswordVerifyScreen.routeName: (context) => PasswordVerifyScreen(),
};