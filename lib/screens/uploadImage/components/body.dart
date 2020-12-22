import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fypapp/components/custom_surfix_icon.dart';
import 'package:fypapp/components/form_error.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/screens/home/components/Product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
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
  String secondaryPassword;
  File imageFile;
  bool _isLoading =false;
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();


  // embedImage(String text, password, image, id) async {
  //
  //   var jsonResponse = null;
  //   var response = await http.post("http://192.168.8.126:8090/sign_in",
  //       headers: <String, String>{"Content-Type":"application/json"},
  //       body: jsonEncode(<String, String>{
  //         'id': id,
  //         'embedText': text,
  //         'secondaryPassword': password,
  //         'image': image,
  //       }));
  //
  //   if(response.statusCode == 200) {
  //     jsonResponse = json.decode(response.body);
  //
  //     var jsonString = jsonResponse['embed_image'];
  //     var jsonException = [];
  //     jsonException = jsonResponse['exception_message'];
  //
  //     if (jsonString == "success") {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //
  //       // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
  //       //     builder: (BuildContext context) => LoginSuccessScreen()), (
  //       //     Route<dynamic> route) => false);
  //     }
  //     else if (jsonString == "fail") {
  //       var jsonErrorMessage = [];
  //       jsonErrorMessage = jsonResponse['errorMessage'];
  //       if(jsonErrorMessage.length != 0){
  //         String error = jsonErrorMessage[0];
  //         if(error.contains("Wrong email")){
  //
  //           Fluttertoast.showToast(
  //               msg: "You enter wrong email or password",
  //               toastLength: Toast.LENGTH_LONG,
  //               gravity: ToastGravity.BOTTOM,
  //               backgroundColor: Colors.tealAccent,
  //               textColor: Colors.black,
  //               fontSize: 18.0);
  //
  //         }else if(error.contains("Account has not")){
  //
  //           Fluttertoast.showToast(
  //               msg: "You have not activate your account",
  //               toastLength: Toast.LENGTH_LONG,
  //               gravity: ToastGravity.BOTTOM,
  //               backgroundColor: Colors.tealAccent,
  //               textColor: Colors.black,
  //               fontSize: 18.0);
  //         }
  //       }
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //
  //     if(jsonException.length != 0 ){
  //       print(jsonException[0]);
  //       Fluttertoast.showToast(
  //           msg: "You are in exception",
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM,
  //           backgroundColor: Colors.tealAccent,
  //           textColor: Colors.black,
  //           fontSize: 18.0);
  //       print("you are in exception");
  //       print(jsonResponse['errorMessage']);
  //     }
  //
  //   }else {
  //     print("Status is not 200");
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     print(response.body);
  //   }
  // }

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
              child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
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
                                          final bytes = await imageFile.readAsBytesSync();
                                          String image64 = base64Encode(bytes);
                                          String effectId = widget.product.id.toString();
                                          print(effectId);
                                          print("hello darren");
                                          print(image64);
                                          // embedImage(textToEmbed, passwordSecondary, image64, id);
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
