// To parse this JSON data, do
//
//     final myGoalsListModel = myGoalsListModelFromJson(jsonString);

import 'dart:convert';

GoalsListModel myGoalsListModelFromJson(String str) =>
    GoalsListModel.fromJson(json.decode(str));

String myGoalsListModelToJson(GoalsListModel data) =>
    json.encode(data.toJson());

class GoalsListModel {
  int? status;
  List<GoalsData>? data;
  String? message;

  GoalsListModel({
    this.status,
    this.data,
    this.message,
  });

  factory GoalsListModel.fromJson(Map<String, dynamic> json) => GoalsListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<GoalsData>.from(
                json["data"]!.map((x) => GoalsData.fromJson(x))),
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

class GoalsData {
  String? id;
  String? goalType;
  String? styleName;
  String? title;
  String? objectiveTitle;
  String? startDate;
  String? targetDate;
  String? score;
  String? photo;
  String? userId;
  String? styleId;
  GoalsData({
    this.id,
    this.goalType,
    this.styleName,
    this.title,
    this.objectiveTitle,
    this.startDate,
    this.targetDate,
    this.score,
    this.photo,
    this.userId,
    this.styleId,
  });

  factory GoalsData.fromJson(Map<String, dynamic> json) => GoalsData(
        id: json["id"].toString(),
        goalType: json["Goal_type"] != null
            ? json["Goal_type"].toString()
            : json["Goal_Type"].toString(),
        styleName: json["Style_Name"].toString(),
        title: json["Title"].toString(),
        objectiveTitle: json["Objective_Title"].toString(),
        startDate: json["Start_Date"].toString(),
        targetDate: json["Target_Date"].toString(),
        score: json["Score"].toString(),
        photo: json["photo"].toString(),
        userId: json["user_id"].toString(),
        styleId: json["style_id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Goal_type": goalType,
        "Style_Name": styleName,
        "Title": title,
        "Objective_Title": objectiveTitle,
        "Start_Date": startDate,
        "Target_Date": targetDate,
        "Score": score,
        "photo": photo,
        "user_id": userId,
        "style_id": styleId,
      };
}
