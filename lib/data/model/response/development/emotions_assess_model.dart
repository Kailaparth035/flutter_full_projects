// To parse this JSON data, do
//
//     final emotionsAssesModel = emotionsAssesModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/purchase_for_assess_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/data/model/response/development/traits_assess_model.dart';

EmotionsAssesModel emotionsAssesModelFromJson(String str) =>
    EmotionsAssesModel.fromJson(json.decode(str));

String emotionsAssesModelToJson(EmotionsAssesModel data) =>
    json.encode(data.toJson());

class EmotionsAssesModel {
  int? status;
  EmotionsAssesData? data;
  String? message;

  EmotionsAssesModel({
    this.status,
    this.data,
    this.message,
  });

  factory EmotionsAssesModel.fromJson(Map<String, dynamic> json) =>
      EmotionsAssesModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : EmotionsAssesData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class EmotionsAssesData {
  String? type1;
  String? type2;
  String? type3;
  String? type4;

  int? shareWithSupervisor;
  List<SliderList>? sliderList;
  List<CheckboxListForEmotions>? checkboxList;
  List<CheckboxListForEmotions>? checkboxListForAssess;

  List<AssessmentPdf>? assessmentPdf;

  String? title;
  String? subTitle;

  String? userId;
  String? styleId;
  int? ratingType;
  // assess purchase data
  List<AssementInstruction>? assementInstruction;

  String? relationWithLoginUser;

  int? isJourneyLicensePurchased;
  String? journeyLicensePurchaseText;

  EmotionsAssesData({
    this.type1,
    this.type2,
    this.type3,
    this.type4,
    this.shareWithSupervisor,
    this.sliderList,
    this.assementInstruction,
    this.title,
    this.subTitle,
    this.userId,
    this.styleId,
    this.ratingType,
    this.relationWithLoginUser,
    this.checkboxListForAssess,
    this.checkboxList,
    this.assessmentPdf,
    this.isJourneyLicensePurchased,
    this.journeyLicensePurchaseText,
  });

  factory EmotionsAssesData.fromJson(Map<String, dynamic> json) =>
      EmotionsAssesData(
        type1: json["type_1"],
        type2: json["type_2"],
        type3: json["type_3"],
        type4: json["type_4"],
        ratingType: json["rating_type"],
        shareWithSupervisor: json["share_with_supervisor"],
        sliderList: json["slider_list"] == null
            ? []
            : List<SliderList>.from(
                json["slider_list"]!.map((x) => SliderList.fromJson(x))),
        assementInstruction: json["assement_instruction"] == null
            ? []
            : List<AssementInstruction>.from(json["assement_instruction"]!
                .map((x) => AssementInstruction.fromJson(x))),
        title: json["title"]?.toString(),
        subTitle: json["sub_title"]?.toString(),
        userId: json["user_id"]?.toString(),
        styleId: json["style_id"]?.toString(),
        relationWithLoginUser: json["relation_with_loginUser"],
        checkboxList: json["checkbox_list"] == null
            ? []
            : List<CheckboxListForEmotions>.from(json["checkbox_list"]!
                .map((x) => CheckboxListForEmotions.fromJson(x))),
        checkboxListForAssess: json["reflect_checkbox_list"] == null
            ? []
            : List<CheckboxListForEmotions>.from(json["reflect_checkbox_list"]!
                .map((x) => CheckboxListForEmotions.fromJson(x))),
        assessmentPdf: json["assessment_pdf"] == null
            ? []
            : List<AssessmentPdf>.from(
                json["assessment_pdf"]!.map((x) => AssessmentPdf.fromJson(x))),
        isJourneyLicensePurchased: json["is_journey_license_purchased"] ?? 0,
        journeyLicensePurchaseText:
            json["journey_license_purchase_text"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "type_1": type1,
        "type_2": type2,
        "type_3": type3,
        "type_4": type4,
        "rating_type": ratingType,
        "share_with_supervisor": shareWithSupervisor,
        "slider_list": sliderList == null
            ? []
            : List<dynamic>.from(sliderList!.map((x) => x.toJson())),
      };
}

class SliderList {
  String? title;
  List<SliderData>? value;
  String? average;
  String? repurationCount;
  String? reflactionCount;
  String? assessCount;
  String? mytargetCount;

  SliderList({
    this.title,
    this.value,
    this.average,
    this.repurationCount,
    this.reflactionCount,
    this.assessCount,
    this.mytargetCount,
  });

  factory SliderList.fromJson(Map<String, dynamic> json) => SliderList(
        title: json["title"],
        value: json["value"] == null
            ? []
            : List<SliderData>.from(
                json["value"]!.map((x) => SliderData.fromJson(x))),
        average: json["average"],
        repurationCount: json["reputation_count"],
        reflactionCount: json["reflection_count"],
        assessCount: json["assess_count"],
        mytargetCount: json["mytarget_count"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value == null
            ? []
            : List<dynamic>.from(value!.map((x) => x.toJson())),
        "average": average,
        "repuration_count": repurationCount,
        "selfreflection_count": reflactionCount,
        "assess_count": assessCount,
        "mytarget_count": mytargetCount,
      };
}

class CheckboxListForEmotions {
  int? areaId;
  String? areaName;

  CheckboxListForEmotions({
    this.areaId,
    this.areaName,
  });

  factory CheckboxListForEmotions.fromJson(Map<String, dynamic> json) =>
      CheckboxListForEmotions(
        areaId: json["AreaId"],
        areaName: json["AreaName"],
      );

  Map<String, dynamic> toJson() => {
        "AreaId": areaId,
        "AreaName": areaName,
      };
}
