// To parse this JSON data, do
//
//     final workskillGoalModel = workskillGoalModelFromJson(jsonString);

import 'dart:convert';

WorkskillGoalModel workskillGoalModelFromJson(String str) =>
    WorkskillGoalModel.fromJson(json.decode(str));

String workskillGoalModelToJson(WorkskillGoalModel data) =>
    json.encode(data.toJson());

class WorkskillGoalModel {
  int? status;
  WorkskillGoalData? data;
  String? message;

  WorkskillGoalModel({
    this.status,
    this.data,
    this.message,
  });

  factory WorkskillGoalModel.fromJson(Map<String, dynamic> json) =>
      WorkskillGoalModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : WorkskillGoalData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class WorkskillGoalData {
  List<WorkSkillSubGoalData>? sliderList;
  String? userId;
  String? styleId;
  String? relationWithLoginUser;

  int? isJourneyLicensePurchased;
  String? journeyLicensePurchaseText;

  WorkskillGoalData({
    this.sliderList,
    this.userId,
    this.styleId,
    this.relationWithLoginUser,
    this.isJourneyLicensePurchased,
    this.journeyLicensePurchaseText,
  });

  factory WorkskillGoalData.fromJson(Map<String, dynamic> json) =>
      WorkskillGoalData(
        userId: json["user_id"],
        styleId: json["style_id"],
        relationWithLoginUser: json["relation_with_loginUser"],
        sliderList: json["slider_list"] == null
            ? []
            : List<WorkSkillSubGoalData>.from(json["slider_list"]!
                .map((x) => WorkSkillSubGoalData.fromJson(x))),
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

class WorkSkillSubGoalData {
  String? title;
  String? description;
  String? score;
  String? percentile;
  String? areaId;

  WorkSkillSubGoalData({
    this.title,
    this.description,
    this.score,
    this.percentile,
    this.areaId,
  });

  factory WorkSkillSubGoalData.fromJson(Map<String, dynamic> json) =>
      WorkSkillSubGoalData(
        title: json["title"],
        description: json["description"],
        score: json["score"],
        percentile: json["percentile"],
        areaId: json["AreaId"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "score": score,
        "percentile": percentile,
      };
}
