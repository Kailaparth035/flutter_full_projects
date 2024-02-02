// To parse this JSON data, do
//
//     final compGoalDetailsModel = compGoalDetailsModelFromJson(jsonString);

import 'dart:convert';

CompGoalDetailsModel compGoalDetailsModelFromJson(String str) =>
    CompGoalDetailsModel.fromJson(json.decode(str));

String compGoalDetailsModelToJson(CompGoalDetailsModel data) =>
    json.encode(data.toJson());

class CompGoalDetailsModel {
  int? status;
  CompGoalDetailsData? data;
  String? message;

  CompGoalDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory CompGoalDetailsModel.fromJson(Map<String, dynamic> json) =>
      CompGoalDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : CompGoalDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class CompGoalDetailsData {
  String? styleId;
  String? userId;
  List<CompGoalTitleList>? sliderList;

  CompGoalDetailsData({
    this.styleId,
    this.userId,
    this.sliderList,
  });

  factory CompGoalDetailsData.fromJson(Map<String, dynamic> json) =>
      CompGoalDetailsData(
        styleId: json["style_id"],
        userId: json["user_id"],
        sliderList: json["slider_list"] == null
            ? []
            : List<CompGoalTitleList>.from(
                json["slider_list"]!.map((x) => CompGoalTitleList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "style_id": styleId,
        "user_id": userId,
        "slider_list": sliderList == null
            ? []
            : List<dynamic>.from(sliderList!.map((x) => x.toJson())),
      };
}

class CompGoalTitleList {
  String? title;
  String? compentecnyDescription;
  String? behavopralDescription;
  String? scoringType;
  String? companyId;
  String? positionId;
  String? positionDetail;
  String? corecompetencyId;
  String? supervisorScore;
  String? idealScore;
  List<SubdataList>? subdataList;
  String? sliderType;

  CompGoalTitleList(
      {this.title,
      this.compentecnyDescription,
      this.behavopralDescription,
      this.scoringType,
      this.companyId,
      this.positionId,
      this.positionDetail,
      this.corecompetencyId,
      this.supervisorScore,
      this.subdataList,
      this.sliderType,
      this.idealScore});

  factory CompGoalTitleList.fromJson(Map<String, dynamic> json) =>
      CompGoalTitleList(
        title: json["title"],
        compentecnyDescription: json["compentecny_description"],
        behavopralDescription: json["behavopral_description"],
        scoringType: json["scoring_type"],
        companyId: json["company_id"],
        positionId: json["position_id"],
        positionDetail: json["position_detail"],
        corecompetencyId: json["corecompetency_id"],
        supervisorScore: json["supervisor_score"],
        subdataList: json["subdataList"] == null
            ? []
            : List<SubdataList>.from(
                json["subdataList"]!.map((x) => SubdataList.fromJson(x))),
        sliderType: json["slider_type"],
        idealScore: json["target_score"] ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "compentecny_description": compentecnyDescription,
        "behavopral_description": behavopralDescription,
        "scoring_type": scoringType,
        "company_id": companyId,
        "position_id": positionId,
        "position_detail": positionDetail,
        "corecompetency_id": corecompetencyId,
        "supervisor_score": supervisorScore,
        "subdataList": subdataList == null
            ? []
            : List<dynamic>.from(subdataList!.map((x) => x.toJson())),
        "slider_type": sliderType,
      };
}

class SubdataList {
  String? title;
  List<SubdataToggle>? value;

  SubdataList({
    this.title,
    this.value,
  });

  factory SubdataList.fromJson(Map<String, dynamic> json) => SubdataList(
        title: json["title"],
        value: json["value"] == null
            ? []
            : List<SubdataToggle>.from(
                json["value"]!.map((x) => SubdataToggle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value == null
            ? []
            : List<dynamic>.from(value!.map((x) => x.toJson())),
      };
}

class SubdataToggle {
  int? id;
  int? compentencyId;
  String? reportType;
  String? suggestedObjective;
  String? focusText;
  String? isRecognized;
  String? isPublished;
  String? targetDate;
  String? isRecognizeShow;
  String? isRecognizeChecked;
  String? isPublishedChecked;
  String? isPublishedDisabled;
  String? isPrirotizeChecked;
  String? isPrirotizeDisabled;

  SubdataToggle({
    this.id,
    this.compentencyId,
    this.reportType,
    this.suggestedObjective,
    this.focusText,
    this.isRecognized,
    this.isPublished,
    this.targetDate,
    this.isRecognizeShow,
    this.isRecognizeChecked,
    this.isPublishedChecked,
    this.isPublishedDisabled,
    this.isPrirotizeChecked,
    this.isPrirotizeDisabled,
  });

  factory SubdataToggle.fromJson(Map<String, dynamic> json) => SubdataToggle(
        id: json["id"],
        compentencyId: json["compentency_id"],
        reportType: json["report_type"],
        suggestedObjective: json["suggested_objective"],
        focusText: json["focusText"],
        isRecognized: json["is_recognized"],
        isPublished: json["is_published"],
        targetDate: json["target_date"],
        isRecognizeShow: json["is_recognize_show"],
        isRecognizeChecked: json["is_recognize_checked"],
        isPublishedChecked: json["is_published_checked"],
        isPublishedDisabled: json["is_published_disabled"],
        isPrirotizeChecked: json["is_prirotize_checked"],
        isPrirotizeDisabled: json["is_prirotize_disabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "compentency_id": compentencyId,
        "report_type": reportType,
        "suggested_objective": suggestedObjective,
        "focusText": focusText,
        "is_recognized": isRecognized,
        "is_published": isPublished,
        "target_date": targetDate,
        "is_recognize_show": isRecognizeShow,
        "is_recognize_checked": isRecognizeChecked,
        "is_published_checked": isPublishedChecked,
        "is_published_disabled": isPublishedDisabled,
        "is_prirotize_checked": isPrirotizeChecked,
        "is_prirotize_disabled": isPrirotizeDisabled,
      };
}
