import 'dart:convert';
import 'dart:io' as Io;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fypapp/global.dart' as globals;
import 'package:fypapp/screens/uploadImage/uploadScreen.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {

  final String jsonImage;

  const Body(this.jsonImage, {Key key}): super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  Image reviewImage;

  @override
  void initState() {
    super.initState();
    checkImage();
  }

  checkImage() async {

    if (reviewImage == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) => UploadScreen()), (
          Route<dynamic> route) => false);
    }
  }

  Widget _displayImageView(){
      return Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: reviewImage,
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
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                _displayImageView(),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
