import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fypapp/components/custom_surfix_icon.dart';
import 'package:fypapp/components/form_error.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/screens/forgot_password/resetPassword/reset_password_screen.dart';
import 'package:fypapp/size_config.dart';
import 'package:fypapp/components/default_button.dart';
import 'package:http/http.dart' as http;

class VerificationForm extends StatefulWidget {
  const VerificationForm({
    Key key,
  }) : super(key: key);

  @override
  _VerificationFormState createState() => _VerificationFormState();
}

class _VerificationFormState extends State<VerificationForm> {
  final TextEditingController tokenController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String token;
  bool _isLoading =false;


  verifyPasswordReset(String token) async {
    // embeddingsystem.us-east-2.elasticbeanstalk.com
    //192.168.8.126:8090
    var jsonResponse = null;
    var response = await http.post("http://192.168.8.126:8090/confirm_change_password",
        body: jsonEncode(<String, String>{
      'token':token,
    }));


    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      var jsonString = jsonResponse['confirm_change_password'];
      var jsonException = [];
      jsonException = jsonResponse['exception_message'];

      if (jsonString == "success") {
        setState(() {
          _isLoading = false;
        });

        Fluttertoast.showToast(
            msg: "You are verified to change password",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.tealAccent,
            textColor: Colors.black,
            fontSize: 15.0);

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) => ResetPasswordScreen()), (
            Route<dynamic> route) => false);

      } else if (jsonString == "fail") {
        var jsonErrorMessage = [];
        jsonErrorMessage = jsonResponse['errorMessage'];
        if (jsonErrorMessage.length != 0) {
          String error = jsonErrorMessage[0];
          if (error.contains("Wrong confirmation token")) {
            Fluttertoast.showToast(
                msg: "You enter the wrong confirmation token or token is expired",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.tealAccent,
                textColor: Colors.black,
                fontSize: 15.0);
            print("you have wrong token");
          }
          else if(error.contains("Code 101")){
            Fluttertoast.showToast(
                msg: "Error occur at database. Please contact us.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.tealAccent,
                textColor: Colors.black,
                fontSize: 15.0);
          }
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
            backgroundColor: Colors.tealAccent,
            textColor: Colors.black,
            fontSize: 15.0);
      }

    }
    else {
      print("Status is not 200");
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: "Failure on server. Please contact us.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.tealAccent,
          textColor: Colors.black,
          fontSize: 15.0);

      print(response.body);
    }
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(
        children: [
          TextFormField(
            controller: tokenController,
            style: TextStyle(color: kTextColor),
            onSaved: (newValue) => token = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kTokenNullError);
              }
            },
            validator: (value) {
              if (value.isEmpty) {
                addError(error: kTokenNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              hintStyle: TextStyle(color: kTextColor),
              labelStyle: TextStyle(color: kTextColor),
              labelText: "Token",
              hintText: "Enter your token",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Question mark.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Verify",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                final String token = tokenController.text;

                setState(() {
                  _isLoading = true;
                });

                verifyPasswordReset(token);
                // Navigator.pushNamed(context, LoginSuccessScreen.routeName);

                // Do what you want to do
              }
            },
          ),
        ],
      ),
    );
  }
}