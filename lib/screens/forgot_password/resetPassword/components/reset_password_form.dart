import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fypapp/screens/sign_in/sign_in_screen.dart';
import 'package:fypapp/size_config.dart';
import 'package:fypapp/components/custom_surfix_icon.dart';
import 'package:fypapp/components/default_button.dart';
import 'package:fypapp/components/form_error.dart';
import 'package:fypapp/constants.dart';
import 'package:http/http.dart' as http;

class ResetPasswordForm extends StatefulWidget {
  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {

  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String password;
  String conform_password;
  bool _isLoading =false;

  final List<String> errors = [];

  confirmChangePassword(String password) async {


    var jsonResponse = null;
    var response = await http.post("http://embeddingsystem.us-east-2.elasticbeanstalk.com/change_password",
        body: jsonEncode(<String, String>{
      'password':password,
    }));

    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      var jsonString = jsonResponse['change_password'];
      var jsonException = [];
      jsonException = jsonResponse['exception_message'];

      if(jsonString == "success") {
        setState(() {
          _isLoading = false;
        });

        Fluttertoast.showToast(
            msg: "You have successfully changed the password",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.tealAccent,
            textColor: Colors.black,
            fontSize: 18.0);

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SignInScreen()), (Route<dynamic> route) => false);
      }
      else if(jsonString == "fail"){
        var jsonErrorMessage = [];
        jsonErrorMessage = jsonResponse['errorMessage'];
        if(jsonErrorMessage.length != 0){
          String error = jsonErrorMessage[0];
          if(error.contains("same as old password")){

            Fluttertoast.showToast(
                msg: "The new password is similar to old password.\nPlease enter again",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.tealAccent,
                textColor: Colors.black,
                fontSize: 18.0);

          }else if(error.contains("Something wrong")){
            Fluttertoast.showToast(
                msg: "Something went wrong with database.\nPlease contact us",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.tealAccent,
                textColor: Colors.black,
                fontSize: 18.0);
          }
        }
        setState(() {
          _isLoading = false;
        });
      }

      if(jsonException.length != 0 ){
        print(jsonException[0]);
        Fluttertoast.showToast(
            msg: "You are in exception",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.tealAccent,
            textColor: Colors.black,
            fontSize: 18.0);
        print("you are in exception");
        print(jsonResponse['errorMessage']);
      }

    } else {
      setState(() {
        _isLoading = false;
      });
      print("Status is not 200");
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
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildConformPassFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Confirm Reset Password",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen

                final String password = passwordController.text;

                setState(() {
                  _isLoading = true;
                });
                confirmChangePassword(password);
                
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      style: TextStyle(color: kTextColor),
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conform_password) {
          removeError(error: kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintStyle: TextStyle(color: kTextColor),
        labelStyle: TextStyle(color: kTextColor),
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      style: TextStyle(color: kTextColor),
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintStyle: TextStyle(color: kTextColor),
        labelStyle: TextStyle(color: kTextColor),
        labelText: "Password",
        hintText: "Enter your new password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }


}
