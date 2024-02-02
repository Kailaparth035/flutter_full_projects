// To parse this JSON data, do
//
//     final leaderStyleTargetModel = leaderStyleTargetModelFromJson(jsonString);

import 'dart:convert';

LeaderStyleTargetModel leaderStyleTargetModelFromJson(String str) =>
    LeaderStyleTargetModel.fromJson(json.decode(str));

String leaderStyleTargetModelToJson(LeaderStyleTargetModel data) =>
    json.encode(data.toJson());

class LeaderStyleTargetModel {
  int? status;
  LeaderStyleTargetDataList? data;
  String? message;

  LeaderStyleTargetModel({
    this.status,
    this.data,
    this.message,
  });

  factory LeaderStyleTargetModel.fromJson(Map<String, dynamic> json) =>
      LeaderStyleTargetModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : LeaderStyleTargetDataList.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class LeaderStyleTargetDataList {
  List<LeaderStyleTargetData>? sliderList;
  String? shareWithSupervisor;

  int? isJourneyLicensePurchased;
  String? journeyLicensePurchaseText;

  LeaderStyleTargetDataList({
    this.sliderList,
    this.shareWithSupervisor,
    this.isJourneyLicensePurchased,
    this.journeyLicensePurchaseText,
  });

  factory LeaderStyleTargetDataList.fromJson(Map<String, dynamic> json) =>
      LeaderStyleTargetDataList(
        sliderList: json["slider_list"] == null
            ? []
            : List<LeaderStyleTargetData>.from(json["slider_list"]!
                .map((x) => LeaderStyleTargetData.fromJson(x))),
        shareWithSupervisor: json["share_with_supervisor"]?.toString(),
        isJourneyLicensePurchased: json["is_journey_license_purchased"] ?? 0,
        journeyLicensePurchaseText:
            json["journey_license_purchase_text"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "slider_list": sliderList == null
            ? []
            : List<dynamic>.from(sliderList!.map((x) => x.toJson())),
      };
}

class LeaderStyleTargetData {
  String? title;
  String? selfReflection;
  String? selfReflectionCount;
  String? reputation;
  String? reputationCount;

  LeaderStyleTargetData({
    this.title,
    this.selfReflection,
    this.selfReflectionCount,
    this.reputation,
    this.reputationCount,
  });

  factory LeaderStyleTargetData.fromJson(Map<String, dynamic> json) =>
      LeaderStyleTargetData(
        title: json["title"],
        selfReflection: json["self_reflection"],
        selfReflectionCount: json["self_reflection_count"],
        reputation: json["reputation"],
        reputationCount: json["reputation_count"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "self_reflection": selfReflection,
        "self_reflection_count": selfReflectionCount,
        "reputation": reputation,
        "reputation_count": reputationCount,
      };
}
