import 'package:flutter/material.dart';
import 'package:fypapp/login_theme.dart';
import 'package:fypapp/routes.dart';
import 'package:fypapp/screens/splash/splash_screen.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Watermark App',
      theme: theme(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}

