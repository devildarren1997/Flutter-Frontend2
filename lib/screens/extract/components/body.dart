import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fypapp/components/custom_surfix_icon.dart';
import 'package:http/http.dart' as http;
import 'package:fypapp/global.dart' as globals;
import 'package:fypapp/screens/home/home_screen.dart';
import 'package:fypapp/size_config.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {

  final String filter;

  const Body(this.filter, {Key key}): super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final TextEditingController secondaryTextController = TextEditingController();
  String extractedText;
  int userId = globals.userId;
  String secondaryPassword;
  bool _isLoading = false;
  File extractImageFile;


  extractImage(String image, password, filterName, int userId) async {

    var jsonResponse = null;
    var response = await http.post("http://192.168.8.126:8090/extractFromImage",
        body: jsonEncode(<String, dynamic>{
          'userId': userId,
          'filter': filterName,
          'secondaryPassword': password,
          'embeddedImage': image,
        }));

    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      var jsonString = jsonResponse['status'];
      var jsonExtractedMessage = jsonResponse['hiddenInformation'];
      // var jsonException = [];
      // jsonException = jsonResponse['exception'];

      if (jsonString == "s") {
        setState(() {
          _isLoading = false;
        });

        extractedText = jsonExtractedMessage;
        if(extractedText != null){
          Fluttertoast.showToast(
              msg: "This is the extract message",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.tealAccent,
              textColor: Colors.black,
              fontSize: 16.0);
        _showExtractDialog(context);
        }else{
          Fluttertoast.showToast(
              msg: "No message found",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.tealAccent,
              textColor: Colors.black,
              fontSize: 16.0);
          extractedText = "We couldn't find message embedded in the image.\nPlease input the correct image";
          _showExtractDialog(context);
        }
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
              fontSize: 16.0);

        }
        setState(() {
          _isLoading = false;
        });
      }

      // if(jsonException.length != 0){
      //   print(jsonException[0]);
      //   Fluttertoast.showToast(
      //       msg: jsonException[0],
      //       toastLength: Toast.LENGTH_LONG,
      //       gravity: ToastGravity.BOTTOM,
      //       backgroundColor: Colors.tealAccent,
      //       textColor: Colors.black,
      //       fontSize: 18.0);
      //   print("you are in exception");
      //
      // }

    }else {
      print("Status is not 200");
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Widget _HomeButton(){
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
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen()), (
                      Route<dynamic> route) => false);
                },
                child: Text(
                  "Return to Home".toUpperCase(),
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


  Widget _displayImageView(){
    if(extractImageFile == null){
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
            "assets/images/SelectImageFromGallery.jpeg",
            fit: BoxFit.fitWidth,
            height: 400,
            width: 400,
          ),
        ),
      );
    }else{
      return GestureDetector(
        onTap: (){
          _showChoiceDialog(context);
        },
        // onTap: (){
        //   Navigator.pushNamed(context, HomeScreen.routeName);
        // },
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.file(
                extractImageFile,
                fit: BoxFit.fitWidth,
                height: 400,
                width: 400,
              ),
              Text(
                "Tap to Select Again",
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
    print(image.path);
    this.setState(() {
      extractImageFile = image;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showExtractDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Text("The Extracted Message: ",
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            content: Text("$extractedText",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Close"))
            ],
          );
        }
    );
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
                  Padding(padding: EdgeInsets.all(6.0)),
                  GestureDetector(
                    child: Text("Gallery",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                    onTap: (){
                      _openGallery(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _SecondaryPassword(){
    return TextFormField(
      controller: secondaryTextController,
      onSaved: (newValue) => secondaryPassword = newValue,
      style: TextStyle(color: kTextColor),

      maxLength: 20,
      maxLengthEnforced: true,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: kTextColor, fontSize: 12),
        labelStyle: TextStyle(color: kTextColor, fontSize: 23),
        counterStyle: TextStyle(color: kTextColor),
        labelText: "Secondary Password",
        hintText: "Enter secondary password (left empty if none)",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading ? Center(child: CircularProgressIndicator()): SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    _displayImageView(),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    _SecondaryPassword(),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: SizedBox(
                              height: 50,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                color: Colors.tealAccent,
                                onPressed: () async {

                                    final String passwordSecondary = secondaryTextController.text;

                                    if(extractImageFile == null){
                                      Fluttertoast.showToast(
                                          msg: "Please insert an image",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.tealAccent,
                                          textColor: Colors.black,
                                          fontSize: 16.0);
                                    }else{

                                      final bytes = await extractImageFile.readAsBytesSync();
                                      String image64 = base64Encode(bytes);
                                      String filterName = widget.filter;
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      extractImage(image64, passwordSecondary, filterName, userId);
                                    }


                                },
                                child: Text(
                                  "Extract Now".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    _HomeButton(),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}