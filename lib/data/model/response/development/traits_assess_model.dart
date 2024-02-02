// To parse this JSON data, do
//
//     final traitAssesModel = traitAssesModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/purchase_for_assess_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';

TraitAssesModel traitAssesModelFromJson(String str) =>
    TraitAssesModel.fromJson(json.decode(str));

String traitAssesModelToJson(TraitAssesModel data) =>
    json.encode(data.toJson());

class TraitAssesModel {
  int? status;
  TraitAssesData? data;
  String? message;

  TraitAssesModel({
    this.status,
    this.data,
    this.message,
  });

  factory TraitAssesModel.fromJson(Map<String, dynamic> json) =>
      TraitAssesModel(
        status: json["status"],
        data:
            json["data"] == null ? null : TraitAssesData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class TraitAssesData {
  int? ratingType;
  String? type1;
  String? type2;
  String? type3;
  String? type4;

  List<SliderData>? sliderList;
  List<AssessmentPdf>? assessmentPdf;

  // for targeting
  String? userId;
  String? styleId;

  String? title;
  String? subTitle;

  // assess purchase data
  List<AssementInstruction>? assementInstruction;

  String? shareWithSupervisor;
  String? relationWithLoginUser;

  // Cognitive targeting
  List<CognitiveObstacle>? cognitiveObstacles;

  int? isJourneyLicensePurchased;
  String? journeyLicensePurchaseText;

  TraitAssesData({
    this.userId,
    this.ratingType,
    this.type1,
    this.type2,
    this.type3,
    this.type4,
    this.sliderList,
    this.assessmentPdf,
    this.shareWithSupervisor,
    this.assementInstruction,
    this.title,
    this.subTitle,
    this.styleId,
    this.relationWithLoginUser,
    this.cognitiveObstacles,
    this.isJourneyLicensePurchased,
    this.journeyLicensePurchaseText,
  });

  factory TraitAssesData.fromJson(Map<String, dynamic> json) => TraitAssesData(
        userId: json["user_id"],
        ratingType: json["rating_type"],
        type1: json["type_1"],
        type2: json["type_2"],
        type3: json["type_3"],
        type4: json["type_4"],
        sliderList: json["slider_list"] == null
            ? []
            : List<SliderData>.from(
                json["slider_list"]!.map((x) => SliderData.fromJson(x))),
        assessmentPdf: json["assessment_pdf"] == null
            ? []
            : List<AssessmentPdf>.from(
                json["assessment_pdf"]!.map((x) => AssessmentPdf.fromJson(x))),
        shareWithSupervisor: json["share_with_supervisor"]?.toString(),
        title: json["title"]?.toString(),
        subTitle: json["sub_title"]?.toString(),
        assementInstruction: json["assement_instruction"] == null
            ? []
            : List<AssementInstruction>.from(json["assement_instruction"]!
                .map((x) => AssementInstruction.fromJson(x))),
        styleId: json["style_id"]?.toString(),
        relationWithLoginUser: json["relation_with_loginUser"],
        cognitiveObstacles: json["cognitive_obstacles"] == null
            ? []
            : List<CognitiveObstacle>.from(json["cognitive_obstacles"]!
                .map((x) => CognitiveObstacle.fromJson(x))),
        isJourneyLicensePurchased: json["is_journey_license_purchased"] ?? 0,
        journeyLicensePurchaseText:
            json["journey_license_purchase_text"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "rating_type": ratingType,
        "type_1": type1,
        "type_2": type2,
        "type_3": type3,
        "type_4": type4,
        "assessment_pdf": assessmentPdf == null
            ? []
            : List<AssessmentPdf>.from(assessmentPdf!.map((x) => x.toJson())),
        "slider_list": sliderList == null
            ? []
            : List<dynamic>.from(sliderList!.map((x) => x.toJson())),
      };
}

class AssessmentPdf {
  String? productName;
  String? pdf;
  String? createdDate;

  AssessmentPdf({
    this.productName,
    this.pdf,
    this.createdDate,
  });

  factory AssessmentPdf.fromJson(Map<String, dynamic> json) => AssessmentPdf(
        productName: json["product_name"],
        pdf: json["pdf"],
        createdDate: json["created_date"],
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "pdf": pdf,
        "created_date": createdDate,
      };
}

class CognitiveObstacle {
  int? areaId;
  String? areaName;
  String? leftMeaning;
  String? selectedAction;

  CognitiveObstacle({
    this.areaId,
    this.areaName,
    this.leftMeaning,
    this.selectedAction,
  });

  factory CognitiveObstacle.fromJson(Map<String, dynamic> json) =>
      CognitiveObstacle(
        areaId: json["AreaId"],
        areaName: json["AreaName"],
        leftMeaning: json["LeftMeaning"],
        selectedAction: json["selected_action"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "AreaId": areaId,
        "AreaName": areaName,
        "LeftMeaning": leftMeaning,
        "selected_action": selectedAction,
      };
}
