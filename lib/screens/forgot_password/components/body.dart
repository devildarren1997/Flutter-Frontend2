import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fypapp/screens/forgot_password/verifyToken/verify_screen.dart';
import 'package:fypapp/size_config.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/components/no_account_text.dart';
import 'package:fypapp/components/form_error.dart';
import 'package:fypapp/components/default_button.dart';
import 'package:fypapp/components/custom_surfix_icon.dart';
import 'package:http/http.dart' as http;

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: kPrimaryLightColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your email and we will send \nyou a verification token to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  List<String> errors = [];
  String email;
  bool _isLoading = false;

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

  forgetPassword(String email) async {

    var jsonResponse = null;
    var response = await http.post("http://embeddingsystem.us-east-2.elasticbeanstalk.com/forget_password",
        body: jsonEncode(<String, String>{
          'email': email,
        }));
    if(response.statusCode == 200) {

      jsonResponse = json.decode(response.body);
      var jsonString = jsonResponse['forget_password'];
      var jsonException = [];
      jsonException = jsonResponse['exception_message'];

      if(jsonString == "success") {

        Fluttertoast.showToast(
            msg: "A token is sent to your email",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.tealAccent,
            textColor: Colors.black,
            fontSize: 18.0);

        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PasswordVerifyScreen()));
      }else if(jsonString == "fail"){
        var jsonErrorMessage = [];
        jsonErrorMessage = jsonResponse['errorMessage'];
        if(jsonErrorMessage.length != 0){
          String error = jsonErrorMessage[0];
          if(error.contains("email does not exist")){

            Fluttertoast.showToast(
                msg: "Email entered does not exist",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.tealAccent,
                textColor: Colors.black,
                fontSize: 18.0);

          }else if(error.contains("Something wrong")){
            Fluttertoast.showToast(
                msg: "Something went wrong with Email Server. Please contact us.",
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
    }
    else {
      print("Status is not 200");
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _isLoading ? Center(child: CircularProgressIndicator()):Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState.validate()) {

                final String email = emailController.text;
                setState(() {
                  _isLoading = true;
                });
                forgetPassword(email);
                // Do what you want to do
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          NoAccountText(),
        ],
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: kTextColor),
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintStyle: TextStyle(color: kTextColor),
        labelStyle: TextStyle(color: kTextColor),
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}