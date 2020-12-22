import 'dart:convert';

import 'package:flutter/material.dart';
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
  bool _tokenValidator = false;

  verifyPasswordReset(String token) async {

    Map data = {
      'token' : token,
    };
    var jsonResponse = null;
    var response = await http.post("http://192.168.8.126:8090/confirm_change_password", body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
          _tokenValidator = true;
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => ResetPasswordScreen()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
        _tokenValidator = false;
      });
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
              }else if(value.isNotEmpty && _tokenValidator == true){
                removeError(error: kInvalidTokenError);
              }
            },
            validator: (value) {
              if (_tokenValidator == false && value.isEmpty) {
                addError(error: kTokenNullError);
                return "";
              } else if (value.isNotEmpty && _tokenValidator == false) {
                addError(error: kInvalidTokenError);
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