import 'dart:convert';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'package:fypapp/screens/home/home_screen.dart';
import 'package:http/http.dart' as http;


class Body extends StatefulWidget {

  final String jsonImage;

  const Body(this.jsonImage, {Key key}): super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  String reviewImage;
  bool _isLoading =false;


  Widget _displayImageView(){
      return Container(
        child: Image.memory(base64Decode(widget.jsonImage)),
        height: 400,
        width: 400,
        alignment: Alignment.topCenter,
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                _displayImageView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
