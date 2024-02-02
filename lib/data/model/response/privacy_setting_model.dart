// To parse this JSON data, do
//
//     final privacySettingModel = privacySettingModelFromJson(jsonString);

import 'dart:convert';

PrivacySettingModel privacySettingModelFromJson(String str) =>
    PrivacySettingModel.fromJson(json.decode(str));

String privacySettingModelToJson(PrivacySettingModel data) =>
    json.encode(data.toJson());

class PrivacySettingModel {
  int? status;
  PrivacySettingData? data;
  String? message;

  PrivacySettingModel({
    this.status,
    this.data,
    this.message,
  });

  factory PrivacySettingModel.fromJson(Map<String, dynamic> json) =>
      PrivacySettingModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : PrivacySettingData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class PrivacySettingData {
  List<ValueData>? questionOneValue;
  int? questionOne;
  int? showPersonalInfo;
  int? showAboutMe;
  int? showFavouriteQuote;
  int? lockProfile;
  List<ValueData>? showPersonalInfoValue;
  List<ValueData>? showAboutMeValue;
  List<ValueData>? showFavouriteQuoteValue;

  PrivacySettingData({
    this.questionOneValue,
    this.questionOne,
    this.showPersonalInfo,
    this.showAboutMe,
    this.showFavouriteQuote,
    this.lockProfile,
    this.showPersonalInfoValue,
    this.showAboutMeValue,
    this.showFavouriteQuoteValue,
  });

  factory PrivacySettingData.fromJson(Map<String, dynamic> json) =>
      PrivacySettingData(
        questionOneValue: json["question_one_value"] == null
            ? []
            : List<ValueData>.from(
                json["question_one_value"]!.map((x) => ValueData.fromJson(x))),
        questionOne: json["question_one"],
        showPersonalInfo: json["show_personal_info"],
        showAboutMe: json["show_about_me"],
        showFavouriteQuote: json["show_favourite_quote"],
        lockProfile: json["lock_profile"],
        showPersonalInfoValue: json["show_personal_info_value"] == null
            ? []
            : List<ValueData>.from(json["show_personal_info_value"]!
                .map((x) => ValueData.fromJson(x))),
        showAboutMeValue: json["show_about_me_value"] == null
            ? []
            : List<ValueData>.from(
                json["show_about_me_value"]!.map((x) => ValueData.fromJson(x))),
        showFavouriteQuoteValue: json["show_favourite_quote_value"] == null
            ? []
            : List<ValueData>.from(json["show_favourite_quote_value"]!
                .map((x) => ValueData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "question_one_value": questionOneValue == null
            ? []
            : List<dynamic>.from(questionOneValue!.map((x) => x.toJson())),
        "question_one": questionOne,
        "show_personal_info": showPersonalInfo,
        "show_about_me": showAboutMe,
        "show_favourite_quote": showFavouriteQuote,
        "lock_profile": lockProfile,
        "show_personal_info_value": showPersonalInfoValue == null
            ? []
            : List<dynamic>.from(showPersonalInfoValue!.map((x) => x.toJson())),
        "show_about_me_value": showAboutMeValue == null
            ? []
            : List<dynamic>.from(showAboutMeValue!.map((x) => x.toJson())),
        "show_favourite_quote_value": showFavouriteQuoteValue == null
            ? []
            : List<dynamic>.from(
                showFavouriteQuoteValue!.map((x) => x.toJson())),
      };
}

class ValueData {
  String? id;
  String? title;
  String? subTitle;

  ValueData({this.id, this.title, this.subTitle});

  factory ValueData.fromJson(Map<String, dynamic> json) => ValueData(
        id: json["id"],
        title: json["title"],
        subTitle: json["sub_title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
