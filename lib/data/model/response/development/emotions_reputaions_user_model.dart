// To parse this JSON data, do
//
//     final emotionsReputationUserModel = emotionsReputationUserModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/reputation_user_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';

EmotionsReputationUserModel emotionsReputationUserModelFromJson(String str) =>
    EmotionsReputationUserModel.fromJson(json.decode(str));

String emotionsReputationUserModelToJson(EmotionsReputationUserModel data) =>
    json.encode(data.toJson());

class EmotionsReputationUserModel {
  int? status;
  EmotionsReputaionUserData? data;
  String? message;

  EmotionsReputationUserModel({
    this.status,
    this.data,
    this.message,
  });

  factory EmotionsReputationUserModel.fromJson(Map<String, dynamic> json) =>
      EmotionsReputationUserModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : EmotionsReputaionUserData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class EmotionsReputaionUserData {
  String? styleId;
  String? userId;

  List<String>? inviteOption;
  String? text;
  String? count;
  List<ReputationUserList>? userList;
  String? mainTitle;
  String? mainSubTitle;
  // List<ReputationFeedback>? reputationFeedback;
  String? isShowPurchaseView;

  String? isEnableSlider;
  String? relationWithLoginUser;

  int? isJourneyLicensePurchased;
  String? journeyLicensePurchaseText;

  EmotionsReputaionUserData({
    this.styleId,
    this.userId,
    this.inviteOption,
    this.text,
    this.count,
    this.userList,
    this.mainTitle,
    this.mainSubTitle,
    // this.reputationFeedback,
    this.isShowPurchaseView,
    this.isEnableSlider,
    this.relationWithLoginUser,
    this.isJourneyLicensePurchased,
    this.journeyLicensePurchaseText,
  });

  factory EmotionsReputaionUserData.fromJson(Map<String, dynamic> json) =>
      EmotionsReputaionUserData(
        styleId: json["style_id"],
        userId: json["user_id"],
        inviteOption: json["invite_option"] == null
            ? []
            : List<String>.from(json["invite_option"]!.map((x) => x)),
        text: json["text"],
        count: json["count"]?.toString(),
        userList: json["user_list"] == null
            ? []
            : List<ReputationUserList>.from(
                json["user_list"]!.map((x) => ReputationUserList.fromJson(x))),
        mainTitle: json["main_title"],
        mainSubTitle: json["main_sub_title"].toString(),
        // reputationFeedback: json["reputation_feedback"] == null
        //     ? []
        //     : List<ReputationFeedback>.from(json["reputation_feedback"]!
        //         .map((x) => ReputationFeedback.fromJson(x))),
        isShowPurchaseView: json["is_show_purchase_view"]?.toString(),
        isEnableSlider: json["is_enable_slider"]?.toString(),
        relationWithLoginUser: json["relation_with_loginUser"]?.toString(),
        isJourneyLicensePurchased: json["is_journey_license_purchased"] ?? 0,
        journeyLicensePurchaseText:
            json["journey_license_purchase_text"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "style_id": styleId,
        "user_id": userId,
        "invite_option": inviteOption == null
            ? []
            : List<dynamic>.from(inviteOption!.map((x) => x)),
        "text": text,
        "count": count,
        // "user_list": userList == null
        //     ? []
        //     : List<dynamic>.from(userList!.map((x) => x.toJson())),
        "main_title": mainTitle,
        // "reputation_feedback": reputationFeedback == null
        //     ? []
        //     : List<dynamic>.from(reputationFeedback!.map((x) => x.toJson())),
      };
}

class ReputationFeedback {
  String? title;
  List<SliderData>? value;
  String? average;
  String? assessCount;

  ReputationFeedback({
    this.title,
    this.value,
    this.average,
    this.assessCount,
  });

  factory ReputationFeedback.fromJson(Map<String, dynamic> json) =>
      ReputationFeedback(
        title: json["title"],
        value: json["value"] == null
            ? []
            : List<SliderData>.from(
                json["value"]!.map((x) => SliderData.fromJson(x))),
        average: json["average"],
        assessCount: json["assess_count"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value == null
            ? []
            : List<dynamic>.from(value!.map((x) => x.toJson())),
        "average": average,
        "assess_count": assessCount,
      };
}
