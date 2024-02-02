// To parse this JSON data, do
//
//     final rolesAndResponsibilityModel = rolesAndResponsibilityModelFromJson(jsonString);

import 'dart:convert';

RolesAndResponsibilityModel rolesAndResponsibilityModelFromJson(String str) =>
    RolesAndResponsibilityModel.fromJson(json.decode(str));

String rolesAndResponsibilityModelToJson(RolesAndResponsibilityModel data) =>
    json.encode(data.toJson());

class RolesAndResponsibilityModel {
  int? status;
  List<RolesAndResponsibilityData>? data;
  String? message;

  RolesAndResponsibilityModel({
    this.status,
    this.data,
    this.message,
  });

  factory RolesAndResponsibilityModel.fromJson(Map<String, dynamic> json) =>
      RolesAndResponsibilityModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<RolesAndResponsibilityData>.from(json["data"]!
                .map((x) => RolesAndResponsibilityData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class RolesAndResponsibilityData {
  int? id;
  String? reviewTitle;
  String? reviewDesc;
  String? score;

  RolesAndResponsibilityData({
    this.id,
    this.reviewTitle,
    this.reviewDesc,
    this.score,
  });

  factory RolesAndResponsibilityData.fromJson(Map<String, dynamic> json) =>
      RolesAndResponsibilityData(
        id: json["id"],
        reviewTitle: json["review_title"],
        reviewDesc: json["review_desc"],
        score: json["score"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "review_title": reviewTitle,
        "review_desc": reviewDesc,
        "score": score,
      };
}
