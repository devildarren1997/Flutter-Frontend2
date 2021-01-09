import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/screens/otp/otp_screen.dart';
import 'package:fypapp/size_config.dart';
import 'package:fypapp/components/custom_surfix_icon.dart';
import 'package:fypapp/components/default_button.dart';
import 'package:fypapp/components/form_error.dart';
import 'package:http/http.dart' as http;
import 'package:fypapp/global.dart' as globals;

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String ip = globals.port;
  String email;
  String password;
  String conform_password;
  bool _isLoading =false;
  String userName;
  bool remember = false;
  final List<String> errors = [];


  signUp(String email, String password, String userName) async {

    // embeddingsystem.us-east-2.elasticbeanstalk.com
    //192.168.8.126:8090
    var jsonResponse = null;
    var response = await http.post("http://$ip/sign_up",
        headers:<String, String>{"Content-Type":"application/json"},
        body:jsonEncode(<String, String>{
          "email" : email,
          "password": password,
          "userName" : userName,
        }));
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      var jsonString = jsonResponse['sign_up'];
      var jsonException = [];
      jsonException = jsonResponse['exception_message'];

      if (jsonString == "success") {
        setState(() {
          _isLoading = false;
        });

        Fluttertoast.showToast(
            msg: "You have successfully register your account\nActivate it",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.tealAccent,
            textColor: Colors.black,
            fontSize: 15.0);

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => OtpScreen()), (Route<dynamic> route) => false);
      }
      else if(jsonString == "fail"){
        var jsonErrorMessage = [];
        jsonErrorMessage = jsonResponse['errorMessage'];
        if(jsonErrorMessage.length != 0){
          String error = jsonErrorMessage[0];
          if(error.contains("You have registered the account before. Please go to")){
            Fluttertoast.showToast(
                msg: "You have registered the account but never activate yet\nPlease check your email for activation token.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.tealAccent,
                textColor: Colors.black,
                fontSize: 15.0);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => OtpScreen()), (Route<dynamic> route) => false);

          }else if(error.contains("contact us")){
            Fluttertoast.showToast(
                msg: "Something went wrong with Email Server. Please contact us.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.tealAccent,
                textColor: Colors.black,
                fontSize: 15.0);

          }else if(error.contains("Account has registered.")){
            Fluttertoast.showToast(
                msg: "The account is registered before.",
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

    }else {
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
      child: _isLoading ? Center(child: CircularProgressIndicator()): Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildConformPassFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildFirstNameFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen
                final String email = emailController.text;
                final String password = passwordController.text;
                final String username = usernameController.text;

                setState(() {
                  _isLoading = true;
                });

                signUp(email, password, username);

              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          Text(
            'By continuing your confirm that you agree \nwith our Term and Condition',
            textAlign: TextAlign.center,
            style: TextStyle(color: kTextColor, fontSize: 12, fontStyle: FontStyle.italic),
          )
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
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
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
  TextFormField buildFirstNameFormField() {
    return TextFormField(
      controller: usernameController,
      onSaved: (newValue) => userName = newValue,
      style: TextStyle(color: kTextColor),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintStyle: TextStyle(color: kTextColor),
        labelStyle: TextStyle(color: kTextColor),
        labelText: "Name",
        hintText: "Enter your name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}

