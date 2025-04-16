import 'dart:convert';

class LoginModel {
  dynamic email;
  dynamic password;

  LoginModel({this.email, this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

LoginDataModel loginDataModelFromJson(String str) =>
    LoginDataModel.fromJson(json.decode(str));

String loginDataModelToJson(LoginDataModel data) => json.encode(data.toJson());

class LoginDataModel {
  bool? success;
  bool? emailVerified;
  String? msg;
  String? token;
  String? refreshToken;
  UserData? userData;

  LoginDataModel({
    this.success,
    this.emailVerified,
    this.msg,
    this.token,
    this.refreshToken,
    this.userData,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) => LoginDataModel(
        success: json["success"],
        emailVerified: json["emailVerified"],
        msg: json["msg"],
        token: json["token"],
        refreshToken: json["refresh_token"],
        userData: json["userData"] == null
            ? null
            : UserData.fromJson(json["userData"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "emailVerified": emailVerified,
        "msg": msg,
        "token": token,
        "refresh_token": refreshToken,
        "userData": userData?.toJson(),
      };
}

class UserData {
  String? id;
  String? registrationMethod;
  String? name;
  String? email;
  bool? verified;
  String? avatar;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  UserData({
    this.id,
    this.registrationMethod,
    this.name,
    this.email,
    this.verified,
    this.avatar,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["_id"],
        registrationMethod: json["registrationMethod"],
        name: json["name"],
        email: json["email"],
        verified: json["verified"],
        avatar: json["avatar"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "registrationMethod": registrationMethod,
        "name": name,
        "email": email,
        "verified": verified,
        "avatar": avatar,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
