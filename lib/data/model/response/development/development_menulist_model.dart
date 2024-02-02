// To parse this JSON data, do
//
//     final developmentLeftMenuListModel = developmentLeftMenuListModelFromJson(jsonString);

import 'dart:convert';

DevelopmentLeftMenuListModel developmentLeftMenuListModelFromJson(String str) =>
    DevelopmentLeftMenuListModel.fromJson(json.decode(str));

String developmentLeftMenuListModelToJson(DevelopmentLeftMenuListModel data) =>
    json.encode(data.toJson());

class DevelopmentLeftMenuListModel {
  int? status;
  DevelopmentLeftMenuListData? data;
  String? message;

  DevelopmentLeftMenuListModel({
    this.status,
    this.data,
    this.message,
  });

  factory DevelopmentLeftMenuListModel.fromJson(Map<String, dynamic> json) =>
      DevelopmentLeftMenuListModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : DevelopmentLeftMenuListData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class DevelopmentLeftMenuListData {
  String? userId;
  String? compentencyShow;
  String? journeyShow;

  DevelopmentLeftMenuListData({
    this.userId,
    this.compentencyShow,
    this.journeyShow,
  });

  factory DevelopmentLeftMenuListData.fromJson(Map<String, dynamic> json) =>
      DevelopmentLeftMenuListData(
        userId: json["user_id"],
        compentencyShow: json["compentency_show"],
        journeyShow: json["journey_show"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "compentency_show": compentencyShow,
        "journey_show": journeyShow,
      };
}
