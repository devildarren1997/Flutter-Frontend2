import 'dart:convert';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fypapp/global.dart' as globals;
import 'package:fypapp/screens/home/home_screen.dart';
import 'package:fypapp/screens/sharing/share_screen.dart';
import 'package:http/http.dart' as http;
import '../../../size_config.dart';

class Body extends StatefulWidget {

  final String jsonImage;

  const Body(this.jsonImage, {Key key}): super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var userId = globals.userId;
  var productId = globals.productId;
  String reviewImage;
  bool _isLoading =false;

  Widget _displayImageView(){
      if(reviewImage == null){
      return Container(
          child: Image.memory(base64Decode(widget.jsonImage)),
            height: 400,
            width: 400,
            alignment: Alignment.topCenter,
        );
  }else{
        return Container(
          child: Image.memory(base64Decode(reviewImage)),
          height: 400,
          width: 400,
          alignment: Alignment.topCenter,
        );
      }
  }


  Widget _confirmButton(){
    return Row(
      children: [
        Expanded(
                child: SizedBox(
                  height: 50,
                  child: MaterialButton(
                    color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  onPressed: () {
                      confirmImage(userId);
                  },
                  child: Text(
                    "Confirm the Embedding".toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
        ),
      ],
    );
  }

  Widget _refreshButton(){
    return Row(
      children: [
        Expanded(

            child: SizedBox(
              height: 50,
              child: MaterialButton(
                color: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                onPressed: () async{
                  refreshImage(userId);
                },
                child: Text(
                  "Refresh the effect".toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }

  Widget _cancelButton(){
    return Row(
      children: [
        Expanded(
            child: SizedBox(
              height: 50,
              child: MaterialButton(
                color: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                onPressed: () async{
                  cancelImage(userId);
                },
                child: Text(
                  "Cancel the embedding".toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    if(productId == 1) {
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
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  _refreshButton(),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  _confirmButton(),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  _cancelButton(),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                ],
              ),
            ),
          ),
        ),
      );
    }else{
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
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  _confirmButton(),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  _cancelButton(),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  refreshImage(int userId) async {

    var jsonResponse = null;
    var response = await http.put("http://192.168.8.126:8090/refresh/"+userId.toString());

    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      var jsonString = jsonResponse['status'];
      var jsonImage = jsonResponse['embeddedImage'];

      if (jsonString == "s") {
        setState(() {
          _isLoading = false;
        });

        Fluttertoast.showToast(
            msg: "You can review your image",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.tealAccent,
            textColor: Colors.black,
            fontSize: 16.0);
        reviewImage = jsonImage;
      }


    }else {
      print("Status is not 200");
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  cancelImage(int userId) async {

    var jsonResponse = null;
    var response = await http.delete("http://192.168.8.126:8090/cancelTempEmbedding/"+userId.toString());

    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      var jsonString = jsonResponse['status'];
      var jsonImage = jsonResponse['embeddedImage'];
      var jsonException = [];
      jsonException = jsonResponse['exception'];

      if (jsonString == "s") {
        setState(() {
          _isLoading = false;
        });

        Fluttertoast.showToast(
            msg: "You have cancel the image embedding\nReturn to Home",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.tealAccent,
            textColor: Colors.black,
            fontSize: 16.0);

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen()), (
            Route<dynamic> route) => false);
      }

      else if (jsonString == "f") {
        var jsonErrorMessage = [];
        jsonErrorMessage = jsonResponse['error'];
        if(jsonErrorMessage.length != 0){

          Fluttertoast.showToast(
              msg: jsonErrorMessage[0],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.tealAccent,
              textColor: Colors.black,
              fontSize: 18.0);


        }
        setState(() {
          _isLoading = false;
        });
      }

      if(jsonException.length != 0){
        print(jsonException[0]);
        Fluttertoast.showToast(
            msg: jsonException[0],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.tealAccent,
            textColor: Colors.black,
            fontSize: 18.0);
        print("you are in exception");

      }


    }else {
      print("Status is not 200");
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  confirmImage(int userId) async {

    var jsonResponse = null;
    var response = await http.get("http://192.168.8.126:8090/confirmEmbeddedImage/"+userId.toString());

    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      var jsonString = jsonResponse['status'];
      var jsonImage = jsonResponse['embeddedImage'];
      var jsonException = [];
      jsonException = jsonResponse['exception'];

      if (jsonString == "s") {
        setState(() {
          _isLoading = false;
        });

        Fluttertoast.showToast(
            msg: "You can now share your image",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.tealAccent,
            textColor: Colors.black,
            fontSize: 16.0);

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) => ShareScreen(jsonImage)), (
            Route<dynamic> route) => false);
      }
      else if (jsonString == "f") {
        var jsonErrorMessage = [];
        jsonErrorMessage = jsonResponse['error'];
        if(jsonErrorMessage.length != 0){

          Fluttertoast.showToast(
              msg: jsonErrorMessage[0],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.tealAccent,
              textColor: Colors.black,
              fontSize: 18.0);


        }
        setState(() {
          _isLoading = false;
        });
      }

      if(jsonException.length != 0){
        print(jsonException[0]);
        Fluttertoast.showToast(
            msg: jsonException[0],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.tealAccent,
            textColor: Colors.black,
            fontSize: 18.0);
        print("you are in exception");

      }

    }else {
      print("Status is not 200");
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }
}
