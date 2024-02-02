// To parse this JSON data, do
//
//     final goalSelectorDetailsModel = goalSelectorDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/traits_goal_model.dart';

GoalSelectorDetailsModel goalSelectorDetailsModelFromJson(String str) =>
    GoalSelectorDetailsModel.fromJson(json.decode(str));

String goalSelectorDetailsModelToJson(GoalSelectorDetailsModel data) =>
    json.encode(data.toJson());

class GoalSelectorDetailsModel {
  int? status;
  GoalSelectorDetailsData? data;
  String? message;

  GoalSelectorDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory GoalSelectorDetailsModel.fromJson(Map<String, dynamic> json) =>
      GoalSelectorDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : GoalSelectorDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class GoalSelectorDetailsData {
  String? styleId;
  String? relationWithLoginUser;
  List<GoalDataForDevelopment>? list;

  GoalSelectorDetailsData({
    this.styleId,
    this.relationWithLoginUser,
    this.list,
  });

  factory GoalSelectorDetailsData.fromJson(Map<String, dynamic> json) =>
      GoalSelectorDetailsData(
        styleId: json["style_id"],
        relationWithLoginUser: json["RelationWithLoginUser"],
        list: json["list"] == null
            ? []
            : List<GoalDataForDevelopment>.from(
                json["list"]!.map((x) => GoalDataForDevelopment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "style_id": styleId,
        "RelationWithLoginUser": relationWithLoginUser,
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}
