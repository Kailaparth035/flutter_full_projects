// To parse this JSON data, do
//
//     final WorkSkillReputaionUserModel = workSkillReputaionModelFromJson(jsonString);

import 'dart:convert';
import 'package:aspirevue/data/model/response/development/reputation_user_model.dart';

WorkSkillReputaionUserModel workSkillReputaionModelFromJson(String str) =>
    WorkSkillReputaionUserModel.fromJson(json.decode(str));

String workSkillReputaionModelToJson(WorkSkillReputaionUserModel data) =>
    json.encode(data.toJson());

class WorkSkillReputaionUserModel {
  int? status;
  WorkSkillReputaionUserData? data;
  String? message;

  WorkSkillReputaionUserModel({
    this.status,
    this.data,
    this.message,
  });

  factory WorkSkillReputaionUserModel.fromJson(Map<String, dynamic> json) =>
      WorkSkillReputaionUserModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : WorkSkillReputaionUserData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class WorkSkillReputaionUserData {
  String? styleId;
  String? userId;
  String? text;
  int? count;
  List<String>? inviteOption;
  List<ReputationUserList>? userList;
  String? isShowPurchaseView;
  String? relationWithLoginUser;
  int? isJourneyLicensePurchased;
  String? journeyLicensePurchaseText;

  WorkSkillReputaionUserData({
    this.styleId,
    this.userId,
    this.text,
    this.count,
    this.inviteOption,
    this.userList,
    this.isShowPurchaseView,
    this.relationWithLoginUser,
    this.isJourneyLicensePurchased,
    this.journeyLicensePurchaseText,
  });

  factory WorkSkillReputaionUserData.fromJson(Map<String, dynamic> json) =>
      WorkSkillReputaionUserData(
        styleId: json["style_id"],
        userId: json["user_id"],
        text: json["text"],
        count: json["count"],
        inviteOption: json["invite_option"] == null
            ? []
            : List<String>.from(json["invite_option"]!.map((x) => x)),
        userList: json["user_list"] == null
            ? []
            : List<ReputationUserList>.from(
                json["user_list"]!.map((x) => ReputationUserList.fromJson(x))),
        isShowPurchaseView: json["is_show_purchase_view"]?.toString(),
        relationWithLoginUser: json["relation_with_loginUser"]?.toString(),
        isJourneyLicensePurchased: json["is_journey_license_purchased"] ?? 0,
        journeyLicensePurchaseText:
            json["journey_license_purchase_text"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "style_id": styleId,
        "user_id": userId,
        "text": text,
        "count": count,
        "invite_option": inviteOption == null
            ? []
            : List<dynamic>.from(inviteOption!.map((x) => x)),
        "user_list": userList == null
            ? []
            : List<dynamic>.from(userList!.map((x) => x.toJson())),
      };
}
