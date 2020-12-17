import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/screens/home/home_screen.dart';
import 'package:image_picker/image_picker.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  File imageFile;

  Widget _displayImageView(){
    if(imageFile == null){
      return GestureDetector(
        onTap: (){
          _showChoiceDialog(context);
        },
        child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Image.asset(
              'assets/images/SelectImage.jpeg',
              fit: BoxFit.fitWidth,
              height: 400,
              width: 400,
            ),
          ),
      );
    }else{
      return GestureDetector(
        onDoubleTap: (){
          _showChoiceDialog(context);
        },
        onTap: (){
          Navigator.pushNamed(context, HomeScreen.routeName);
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.file(
                imageFile,
                fit: BoxFit.fitWidth,
                height: 400,
                width: 400,
              ),
              Text(
                  "Tap to Continue\nDouble Tap to Select Again",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  _openGallery(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = image;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = image;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Select image from: ",
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                    onTap: (){
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  GestureDetector(
                    child: Text("Camera",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                    onTap: (){
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _displayImageView(),
          ],
        ),
      ),
    );
  }
}
