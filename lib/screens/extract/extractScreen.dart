import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fypapp/screens/home/home_screen.dart';

import '../../constants.dart';
import 'components/body.dart';

class ExtractScreen extends StatefulWidget {
  static String routeName = "/extract_home";

  final String filter;

  const ExtractScreen(this.filter, {Key key}): super(key: key);

  @override
  _ExtractScreenState createState() => _ExtractScreenState();
}

class _ExtractScreenState extends State<ExtractScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Extract Image',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Muli',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Body(widget.filter),
    );
  }
}
