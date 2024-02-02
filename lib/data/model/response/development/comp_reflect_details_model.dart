// To parse this JSON data, do
//
//     final compReflectDetailsModel = compReflectDetailsModelFromJson(jsonString);

import 'dart:convert';

CompReflectDetailsModel compReflectDetailsModelFromJson(String str) =>
    CompReflectDetailsModel.fromJson(json.decode(str));

String compReflectDetailsModelToJson(CompReflectDetailsModel data) =>
    json.encode(data.toJson());

class CompReflectDetailsModel {
  int? status;
  CompReflectDetailsData? data;
  String? message;

  CompReflectDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory CompReflectDetailsModel.fromJson(Map<String, dynamic> json) =>
      CompReflectDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : CompReflectDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class CompReflectDetailsData {
  String? styleId;
  String? userId;
  List<SliderListForCompetancy>? sliderList;
  List<SuggetionList>? suggetionList;

  CompReflectDetailsData({
    this.styleId,
    this.userId,
    this.sliderList,
    this.suggetionList,
  });

  factory CompReflectDetailsData.fromJson(Map<String, dynamic> json) =>
      CompReflectDetailsData(
        styleId: json["style_id"],
        userId: json["user_id"],
        sliderList: json["slider_list"] == null
            ? []
            : List<SliderListForCompetancy>.from(json["slider_list"]!
                .map((x) => SliderListForCompetancy.fromJson(x))),
        suggetionList: json["suggetion_list"] == null
            ? []
            : List<SuggetionList>.from(
                json["suggetion_list"]!.map((x) => SuggetionList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "style_id": styleId,
        "user_id": userId,
        "slider_list": sliderList == null
            ? []
            : List<dynamic>.from(sliderList!.map((x) => x.toJson())),
        "suggetion_list": suggetionList == null
            ? []
            : List<dynamic>.from(suggetionList!.map((x) => x.toJson())),
      };
}

class SliderListForCompetancy {
  String? title;
  String? description;
  String? scoringType;
  String? companyId;
  String? positionId;
  String? positionDetail;
  String? corecompetencyId;
  String? rubricTitle;
  String? rubricDescription;
  String? reflectScore;
  String? sliderType;

  SliderListForCompetancy({
    this.title,
    this.description,
    this.scoringType,
    this.companyId,
    this.positionId,
    this.positionDetail,
    this.corecompetencyId,
    this.rubricTitle,
    this.rubricDescription,
    this.reflectScore,
    this.sliderType,
  });

  factory SliderListForCompetancy.fromJson(Map<String, dynamic> json) =>
      SliderListForCompetancy(
        title: json["title"],
        description: json["description"],
        scoringType: json["scoring_type"],
        companyId: json["company_id"],
        positionId: json["position_id"],
        positionDetail: json["position_detail"],
        corecompetencyId: json["corecompetency_id"],
        rubricTitle: json["rubric_title"],
        rubricDescription: json["rubric_description"],
        reflectScore: json["reflect_score"]?.toString(),
        sliderType: json["slider_type"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "scoring_type": scoringType,
        "company_id": companyId,
        "position_id": positionId,
        "position_detail": positionDetail,
        "corecompetency_id": corecompetencyId,
        "rubric_title": rubricTitle,
        "rubric_description": rubricDescription,
        "reflect_score": reflectScore,
        "slider_type": sliderType,
      };
}

class SuggetionList {
  String? title;
  List<String>? list;

  SuggetionList({
    this.title,
    this.list,
  });

  factory SuggetionList.fromJson(Map<String, dynamic> json) => SuggetionList(
        title: json["title"],
        list: json["list"] == null
            ? []
            : List<String>.from(json["list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x)),
      };
}
