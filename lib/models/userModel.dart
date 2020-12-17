// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String email;
  String password;
  String userName;

  UserModel({
    this.email,
    this.password,
    this.userName,
  });



  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json["email"],
    password: json["password"],
    userName: json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "userName": userName,
  };

}