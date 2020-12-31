import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fypapp/components/custom_surfix_icon.dart';
import 'package:fypapp/components/form_error.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/screens/home/components/Product.dart';
import 'package:fypapp/screens/review/review_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fypapp/global.dart' as globals;
import '../../../size_config.dart';

class Body extends StatefulWidget {

  final Product product;

  const Body({Key key, this.product}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController embedTextController = TextEditingController();
  final TextEditingController secondaryTextController = TextEditingController();
  String embedText;
  int userId = globals.userId;
  String secondaryPassword;
  File imageFile;
  bool _isLoading =false;
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();


  embedImage(String text, password, image, filterName,imageName, int userId) async {

    var jsonResponse = null;
    var response = await http.post("http://192.168.8.126:8090/getTempEmbeddedImage",
        body: jsonEncode(<String, dynamic>{
          'userId': userId,
          'filter': filterName,
          'name': imageName,
          'embedText': text,
          'secondaryPassword': password,
          'imageBase64': image,
        }));

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
            msg: "You can review your image",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.tealAccent,
            textColor: Colors.black,
            fontSize: 16.0);

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) => ReviewScreen(jsonImage)), (
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
        onTap: (){
          _showChoiceDialog(context);
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
    this.setState(() {
      imageFile = image;
      globals.imagePath = image.path;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = image;
      globals.imagePath = image.path;
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

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Widget _EmbedText(){
    return TextFormField(
      controller: embedTextController,
      onSaved: (newValue) => embedText = newValue,
      style: TextStyle(color: kTextColor),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmbedTextNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmbedTextNullError);
          return "";
        }
        return null;
      },
      maxLength: 20,
      maxLengthEnforced: true,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: kTextColor, fontSize: 12.5),
        labelStyle: TextStyle(color: kTextColor, fontSize: 23),
        counterStyle: TextStyle(color: kTextColor),
        labelText: "Embed Text",
        hintText: "Enter the message you want to embed",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }


  Widget _SecondaryPassword(){
    return TextFormField(
      controller: secondaryTextController,
      onSaved: (newValue) => secondaryPassword = newValue,
      style: TextStyle(color: kTextColor),

      maxLength: 20,
      maxLengthEnforced: true,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: kTextColor, fontSize: 12.5),
        labelStyle: TextStyle(color: kTextColor, fontSize: 23),
        counterStyle: TextStyle(color: kTextColor),
        labelText: "Secondary Password",
        hintText: "Enter secondary password (can be left empty)",
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
      child: SizedBox(
        width: double.infinity,
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:  <Widget>[
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    _displayImageView(),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                        _EmbedText(),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        _SecondaryPassword(),
                        FormError(errors: errors),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18)),
                                    color: widget.product.color,
                                    onPressed: () async {
                                      if(_formKey.currentState.validate()){
                                        _formKey.currentState.save();
                                        final String textToEmbed = embedTextController.text;
                                        final String passwordSecondary = secondaryTextController.text;

                                        if(imageFile == null){
                                          Fluttertoast.showToast(
                                              msg: "Please insert an image",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.tealAccent,
                                              textColor: Colors.black,
                                              fontSize: 16.0);
                                        }else{
                                          String imagePath = imageFile.path.split('/').last;
                                          String imageName = imagePath.split('.').first;
                                          final bytes = await imageFile.readAsBytesSync();
                                          String image64 = base64Encode(bytes);
                                          String filterName = widget.product.filter;
                                          globals.productId = widget.product.id;
                                          setState(() {
                                            _isLoading = true;
                                          });

                                          embedImage(textToEmbed, passwordSecondary, image64, filterName, imageName, userId);
                                        }

                                      }
                                    },
                                    child: Text(
                                      "Embed Now".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                          SizedBox(height: SizeConfig.screenHeight * 0.04),
                      ],
                    ),
                    ),
                  ],
                ),
            ),
          ),
      ),
    );
  }
}

// _isLoading ? Center(child: CircularProgressIndicator()):
