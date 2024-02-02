// To parse this JSON data, do
//
//     final signatureSettingModel = signatureSettingModelFromJson(jsonString);

import 'dart:convert';

SignatureSettingModel signatureSettingModelFromJson(String str) =>
    SignatureSettingModel.fromJson(json.decode(str));

String signatureSettingModelToJson(SignatureSettingModel data) =>
    json.encode(data.toJson());

class SignatureSettingModel {
  int? status;
  SignatureSettingData? data;
  String? message;

  SignatureSettingModel({
    this.status,
    this.data,
    this.message,
  });

  factory SignatureSettingModel.fromJson(Map<String, dynamic> json) =>
      SignatureSettingModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : SignatureSettingData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class SignatureSettingData {
  String? mySignature;
  String? purposeStatement;
  String? importantToMe;
  String? teamSignatureIdentity;
  List<ShowAboutMe>? showAboutMe;
  int? showAboutMeValue;

  String? signatureExerciseUrl;
  String? purposingExerciseUrl;

  SignatureSettingData({
    this.mySignature,
    this.purposeStatement,
    this.importantToMe,
    this.teamSignatureIdentity,
    this.showAboutMe,
    this.showAboutMeValue,
    this.signatureExerciseUrl,
    this.purposingExerciseUrl,
  });

  factory SignatureSettingData.fromJson(Map<String, dynamic> json) =>
      SignatureSettingData(
        mySignature: json["my_signature"],
        purposeStatement: json["purpose_statement"],
        importantToMe: json["important_to_me"],
        teamSignatureIdentity: json["team_signature_identity"],
        showAboutMe: json["show_about_me"] == null
            ? []
            : List<ShowAboutMe>.from(
                json["show_about_me"]!.map((x) => ShowAboutMe.fromJson(x))),
        showAboutMeValue: json["show_about_me_value"],
        signatureExerciseUrl: json["signature_exercise_url"],
        purposingExerciseUrl: json["purposing_exercise_url"],
      );

  Map<String, dynamic> toJson() => {
        "my_signature": mySignature,
        "purpose_statement": purposeStatement,
        "important_to_me": importantToMe,
        "team_signature_identity": teamSignatureIdentity,
        "show_about_me": showAboutMe == null
            ? []
            : List<dynamic>.from(showAboutMe!.map((x) => x.toJson())),
        "show_about_me_value": showAboutMeValue,
        "signature_exercise_url": signatureExerciseUrl,
        "purposing_exercise_url": purposingExerciseUrl,
      };
}

class ShowAboutMe {
  String? id;
  String? title;

  ShowAboutMe({
    this.id,
    this.title,
  });

  factory ShowAboutMe.fromJson(Map<String, dynamic> json) => ShowAboutMe(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
