import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fypapp/components/no_account_text.dart';
import 'package:fypapp/size_config.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/components/custom_surfix_icon.dart';
import 'package:fypapp/components/default_button.dart';
import 'package:fypapp/components/form_error.dart';
import 'package:fypapp/screens/forgot_password/forgot_password_screen.dart';
import 'package:fypapp/screens/login_success/login_success_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fypapp/global.dart' as globals;
import 'package:http/http.dart' as http;


class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}



class _SignFormState extends State<SignForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool remember = false;
  var jsonUserId = null;
  bool _isLoading =false;
  final List<String> errors = [];



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

  signIn(String email, password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var jsonResponse = null;
    var response = await http.post("http://embeddingsystem.us-east-2.elasticbeanstalk.com/sign_in",
        headers: <String, String>{"Content-Type":"application/json"},
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }));
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      var jsonString = jsonResponse['sign_in'];
      var jsonException = [];
      jsonException = jsonResponse['exception_message'];
      jsonUserId = jsonResponse['id'];

      if (jsonString == "success") {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) => LoginSuccessScreen(jsonUserId)), (
            Route<dynamic> route) => false);
      }
      else if (jsonString == "fail") {
        var jsonErrorMessage = [];
         jsonErrorMessage = jsonResponse['errorMessage'];
        if(jsonErrorMessage.length != 0){
          String error = jsonErrorMessage[0];
          if(error.contains("Wrong email")){

            Fluttertoast.showToast(
                msg: "You enter wrong email or password",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.tealAccent,
                textColor: Colors.black,
                fontSize: 18.0);

          }else if(error.contains("Account has not")){

            Fluttertoast.showToast(
                msg: "You have not activate your account",
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

    }else {
      print("Status is not 200");
        setState(() {
          _isLoading = false;
        });
        print(response.body);
      }
  }



  @override
  Widget build(BuildContext context) {
    return  Form(
      key: _formKey,
      child: _isLoading ? Center(child: CircularProgressIndicator()):Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Theme(
                child: Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
                data: ThemeData(
                  unselectedWidgetColor: Colors.white,
                ),

              ),

              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Sign In",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                final String email = emailController.text;
                final String password = passwordController.text;

                // if all are valid then go to success screen
                setState(() {
                  _isLoading = true;
                });
                signIn(email, password);
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.08),
          SizedBox(height: getProportionateScreenHeight(20)),
          NoAccountText(),
          SizedBox(height: getProportionateScreenHeight(20)),
        ],
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
        return null;
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
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
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