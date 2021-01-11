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
  final String ip = globals.port;
  bool _isLoading =false;

  Widget _displayImageView(){
      return Container(
          child: Image.memory(base64Decode(widget.jsonImage)),
            height: 300,
            width: 400,
            alignment: Alignment.topCenter,
        );
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
                    setState(() {
                      _isLoading = true;
                    });
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
                  setState(() {
                    _isLoading = true;
                  });

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
      return SafeArea(
        child: _isLoading ? Center(child: CircularProgressIndicator()):SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
            child: SingleChildScrollView(
              child: Container(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(height: SizeConfig.screenHeight * 0.04),
                          _displayImageView(),
                          SizedBox(height: SizeConfig.screenHeight * 0.02),
                          _confirmButton(),
                          SizedBox(height: SizeConfig.screenHeight * 0.03),
                          _cancelButton(),
                          SizedBox(height: SizeConfig.screenHeight * 0.03),
                        ],
                      ),
                  ),
              ),
            ),
          ),
        ),
      );
  }

  cancelImage(int userId) async {

    var jsonResponse = null;
    var response = await http.delete("http://$ip/cancelTempEmbedding/"+userId.toString());

    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      var jsonString = jsonResponse['status'];
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
            backgroundColor: Colors.greenAccent,
            textColor: Colors.black,
            fontSize: 15.0);

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
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 15.0);


        }
        setState(() {
          _isLoading = false;
        });
      }

      if(jsonException.length != 0){
        print("you are in exception");
        print(jsonException[0]);
        Fluttertoast.showToast(
            msg: "Some problems occur with the application. Please contact us.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 15.0);
      }


    }else {
      print("Status is not 200");
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: "Failure on server. Please contact us.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 15.0);

      print(response.body);
    }
  }

  confirmImage(int userId) async {

    var jsonResponse = null;
    var response = await http.get("http://$ip/confirmEmbeddedImage/"+userId.toString());

    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      var jsonString = jsonResponse['status'];
      var jsonImage = widget.jsonImage;
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
            backgroundColor: Colors.greenAccent,
            textColor: Colors.black,
            fontSize: 15.0);

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
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 15.0);


        }
        setState(() {
          _isLoading = false;
        });
      }

      if(jsonException.length != 0){
        print("you are in exception");
        print(jsonException[0]);
        Fluttertoast.showToast(
            msg: "Some problems occur with the application. Please contact us.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 15.0);
      }

    }else {
      print("Status is not 200");
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: "Failure on server. Please contact us.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 15.0);

      print(response.body);
    }
  }
}
