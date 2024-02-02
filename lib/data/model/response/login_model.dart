// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  int? status;
  LoginData? data;
  String? message;

  LoginModel({
    this.status,
    this.data,
    this.message,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        data: json["data"] == null ? null : LoginData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class LoginData {
  int? id;
  int? roleId;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? photo;
  String? coverPhoto;
  String? apiKey;
  List<String>? licenseList;
  int? showTrailScreen;
  String? sampleProfilePicture;
  int? appWelcomeScreenShow;
  bool? isShowTourOverlay;

  int? isSmsConsent;
  int? isSmsConsentShow;

  String? animationVideo;
  LoginData(
      {this.id,
      this.roleId,
      this.email,
      this.firstName,
      this.lastName,
      this.phone,
      this.photo,
      this.coverPhoto,
      this.apiKey,
      this.licenseList,
      this.animationVideo,
      this.showTrailScreen,
      this.appWelcomeScreenShow,
      this.isShowTourOverlay,
      this.sampleProfilePicture,
      this.isSmsConsent,
      this.isSmsConsentShow});

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        id: json["id"],
        roleId: json["role_id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        photo: json["photo"],
        coverPhoto: json["cover_photo"],
        apiKey: json["api_key"],
        animationVideo: json["animation_video"],
        showTrailScreen: json["show_trail_screen"],
        sampleProfilePicture: json["sample_profile_picture"],
        appWelcomeScreenShow: json["app_welcome_screen_show"],
        isShowTourOverlay: json["is_show_tour_overlay"],
        isSmsConsent: json["is_sms_consent"],
        isSmsConsentShow: json["is_sms_consent_show"],
        licenseList: json["license_list"] == null
            ? []
            : List<String>.from(json["license_list"]!.map((x) => x.toString())),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "photo": photo,
        "cover_photo": coverPhoto,
        "api_key": apiKey,
        "animation_video": animationVideo,
        "license_list": licenseList == null
            ? []
            : List<dynamic>.from(licenseList!.map((x) => x)),
      };
}
