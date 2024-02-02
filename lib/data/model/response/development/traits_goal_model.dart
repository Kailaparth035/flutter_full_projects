// To parse this JSON data, do
//
//     final traitsGoalModel = traitsGoalModelFromJson(jsonString);

import 'dart:convert';

TraitsGoalModel traitsGoalModelFromJson(String str) =>
    TraitsGoalModel.fromJson(json.decode(str));

String traitsGoalModelToJson(TraitsGoalModel data) =>
    json.encode(data.toJson());

class TraitsGoalModel {
  int? status;
  TraitsGoalData? data;
  String? message;

  TraitsGoalModel({
    this.status,
    this.data,
    this.message,
  });

  factory TraitsGoalModel.fromJson(Map<String, dynamic> json) =>
      TraitsGoalModel(
        status: json["status"],
        data:
            json["data"] == null ? null : TraitsGoalData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class TraitsGoalData {
  String? userId;
  String? styleId;
  String? relationWithLoginUser;

  List<GoalDataForDevelopment>? sliderList;
  List<GoalDataForDevelopment>? sliderListRadio;

  int? isJourneyLicensePurchased;
  String? journeyLicensePurchaseText;

  TraitsGoalData({
    this.sliderList,
    this.sliderListRadio,
    this.userId,
    this.styleId,
    this.relationWithLoginUser,
    this.isJourneyLicensePurchased,
    this.journeyLicensePurchaseText,
  });

  factory TraitsGoalData.fromJson(Map<String, dynamic> json) => TraitsGoalData(
        sliderList: json["slider_list"] == null
            ? []
            : List<GoalDataForDevelopment>.from(json["slider_list"]!
                .map((x) => GoalDataForDevelopment.fromJson(x))),
        sliderListRadio: json["slider_list_radio"] == null
            ? []
            : List<GoalDataForDevelopment>.from(json["slider_list_radio"]!
                .map((x) => GoalDataForDevelopment.fromJson(x))),
        userId: json["user_id"]?.toString(),
        styleId: json["style_id"]?.toString(),
        relationWithLoginUser: json["relation_with_loginUser"]?.toString(),
        isJourneyLicensePurchased: json["is_journey_license_purchased"] ?? 0,
        journeyLicensePurchaseText:
            json["journey_license_purchase_text"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "style_id": styleId,
        "relation_with_loginUser": relationWithLoginUser,
        "slider_list": sliderList == null
            ? []
            : List<dynamic>.from(sliderList!.map((x) => x.toJson())),
      };
}

class GoalDataForDevelopment {
  String? prioritizeChecked;
  String? prioritizeEnable;
  String? publishEnable;
  String? publishChecked;
  String? recognizeShow;
  String? recognizeEnable;
  String? recognizeChecked;
  String? targetDate;
  String? skill;
  String? difference;
  String? behaviorDesc;
  String? suggesstedObj;
  String? title;
  String? riskScore;
  String? area;
  String? areaId;
  String? markingType;
  String? action;
  String? beMore;
  String? dailyq;
  String? pursuits;
  String? dailyToBe;
  String? goalId;
  String? scaleId;

  String? valueDrivers;

  GoalDataForDevelopment(
      {this.prioritizeChecked,
      this.prioritizeEnable,
      this.publishEnable,
      this.publishChecked,
      this.recognizeShow,
      this.recognizeEnable,
      this.recognizeChecked,
      this.targetDate,
      this.skill,
      this.difference,
      this.behaviorDesc,
      this.suggesstedObj,
      this.title,
      this.riskScore,
      this.area,
      this.areaId,
      this.markingType,
      this.action,
      this.beMore,
      this.dailyq,
      this.pursuits,
      this.dailyToBe,
      this.goalId,
      this.scaleId,
      this.valueDrivers});

  factory GoalDataForDevelopment.fromJson(Map<String, dynamic> json) =>
      GoalDataForDevelopment(
        prioritizeChecked: json["prioritize_checked"],
        prioritizeEnable: json["prioritize_enable"],
        publishEnable: json["publish_enable"],
        publishChecked: json["publish_checked"],
        recognizeShow: json["recognize_show"],
        recognizeEnable: json["recognize_enable"],
        recognizeChecked: json["recognize_checked"],
        targetDate: json["targetDate"],
        skill: json["skill"],
        difference: json["difference"],
        behaviorDesc: json["behavior_desc"],
        suggesstedObj: json["suggessted_obj"],
        title: json["title"],
        riskScore: json["risk_score"],
        area: json["area"],
        areaId: json["AreaId"]?.toString(),
        markingType: json["marking_type"]?.toString(),
        action: json["action"],
        beMore: json["bemore"],
        dailyq: json["dailyq"],
        pursuits: json["pursuits"],
        dailyToBe: json["daily_to_be"],
        goalId: json["goal_id"]?.toString(),
        scaleId: json["scale_id"]?.toString(),
        valueDrivers: json["value_drivers"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "prioritize_checked": prioritizeChecked,
        "prioritize_enable": prioritizeEnable,
        "publish_enable": publishEnable,
        "publish_checked": publishChecked,
        "recognize_show": recognizeShow,
        "recognize_enable": recognizeEnable,
        "recognize_checked": recognizeChecked,
        "targetDate": targetDate,
        "skill": skill,
        "difference": difference,
        "behavior_desc": behaviorDesc,
        "suggessted_obj": suggesstedObj,
        "title": title,
        "risk_score": riskScore,
        "area": area,
        "action": action,
        "bemore": beMore,
        "pursuits": pursuits,
      };
}
