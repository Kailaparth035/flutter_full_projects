// To parse this JSON data, do
//
//     final GoalfollowersModel = gjsonString);

import 'dart:convert';

GoalFollowersModel goalfollowersModelFromJson(String str) =>
    GoalFollowersModel.fromJson(json.decode(str));

String goalfollowersModelToJson(GoalFollowersModel data) =>
    json.encode(data.toJson());

class GoalFollowersModel {
  int? status;
  List<GoalFollowersData>? data;
  String? message;

  GoalFollowersModel({
    this.status,
    this.data,
    this.message,
  });

  factory GoalFollowersModel.fromJson(Map<String, dynamic> json) =>
      GoalFollowersModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<GoalFollowersData>.from(
                json["data"]!.map((x) => GoalFollowersData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<GoalFollowersData>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class GoalFollowersData {
  int? id;
  String? name;

  GoalFollowersData({
    this.id,
    this.name,
  });

  factory GoalFollowersData.fromJson(Map<String, dynamic> json) =>
      GoalFollowersData(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
