// To parse this JSON data, do
//
//     final compTargattingDetailsModel = compTargattingDetailsModelFromJson(jsonString);

import 'dart:convert';

CompTargattingDetailsModel compTargattingDetailsModelFromJson(String str) =>
    CompTargattingDetailsModel.fromJson(json.decode(str));

String compTargattingDetailsModelToJson(CompTargattingDetailsModel data) =>
    json.encode(data.toJson());

class CompTargattingDetailsModel {
  int? status;
  CompTargattingDetailsData? data;
  String? message;

  CompTargattingDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory CompTargattingDetailsModel.fromJson(Map<String, dynamic> json) =>
      CompTargattingDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : CompTargattingDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class CompTargattingDetailsData {
  String? styleId;
  String? userId;
  List<SliderListForTargating>? sliderList;
  List<PositionList>? positionList;
  String? positionId;
  List<String>? titleList;

  CompTargattingDetailsData({
    this.styleId,
    this.userId,
    this.sliderList,
    this.positionList,
    this.positionId,
    this.titleList,
  });

  factory CompTargattingDetailsData.fromJson(Map<String, dynamic> json) =>
      CompTargattingDetailsData(
        styleId: json["style_id"],
        userId: json["user_id"],
        sliderList: json["slider_list"] == null
            ? []
            : List<SliderListForTargating>.from(json["slider_list"]!
                .map((x) => SliderListForTargating.fromJson(x))),
        positionList: json["position_list"] == null
            ? []
            : List<PositionList>.from(
                json["position_list"]!.map((x) => PositionList.fromJson(x))),
        positionId: json["position_id"],
        titleList: json["title_list"] == null
            ? []
            : List<String>.from(json["title_list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "style_id": styleId,
        "user_id": userId,
        "slider_list": sliderList == null
            ? []
            : List<dynamic>.from(sliderList!.map((x) => x.toJson())),
        "position_list": positionList == null
            ? []
            : List<dynamic>.from(positionList!.map((x) => x.toJson())),
        "position_id": positionId,
        "title_list": titleList == null
            ? []
            : List<dynamic>.from(titleList!.map((x) => x)),
      };
}

class PositionList {
  String? id;
  String? name;

  PositionList({
    this.id,
    this.name,
  });

  factory PositionList.fromJson(Map<String, dynamic> json) => PositionList(
        id: json["id"]?.toString(),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class SliderListForTargating {
  String? title;
  String? description;
  String? scoringType;
  String? companyId;
  String? positionId;
  String? positionDetail;
  String? corecompetencyId;
  String? reflectScore;
  String? targetScore;
  String? peerScore;
  String? reportScore;
  String? supervisorScore;
  String? sliderType;

  SliderListForTargating({
    this.title,
    this.description,
    this.scoringType,
    this.companyId,
    this.positionId,
    this.positionDetail,
    this.corecompetencyId,
    this.reflectScore,
    this.targetScore,
    this.peerScore,
    this.reportScore,
    this.supervisorScore,
    this.sliderType,
  });

  factory SliderListForTargating.fromJson(Map<String, dynamic> json) =>
      SliderListForTargating(
        title: json["title"],
        description: json["description"],
        scoringType: json["scoring_type"],
        companyId: json["company_id"],
        positionId: json["position_id"],
        positionDetail: json["position_detail"],
        corecompetencyId: json["corecompetency_id"],
        reflectScore: json["reflect_score"],
        targetScore: json["target_score"],
        peerScore: json["peer_score"],
        reportScore: json["report_score"],
        supervisorScore: json["supervisor_score"],
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
        "reflect_score": reflectScore,
        "target_score": targetScore,
        "peer_score": peerScore,
        "report_score": reportScore,
        "supervisor_score": supervisorScore,
        "slider_type": sliderType,
      };
}
