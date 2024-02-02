// To parse this JSON data, do
//
//     final dashboardDailyQListModel = dashboardDailyQListModelFromJson(jsonString);

import 'dart:convert';

DashboardDailyQListModel dashboardDailyQListModelFromJson(String str) =>
    DashboardDailyQListModel.fromJson(json.decode(str));

String dashboardDailyQListModelToJson(DashboardDailyQListModel data) =>
    json.encode(data.toJson());

class DashboardDailyQListModel {
  int? status;
  List<DailyQDataForDashboard>? data;
  String? message;

  DashboardDailyQListModel({
    this.status,
    this.data,
    this.message,
  });

  factory DashboardDailyQListModel.fromJson(Map<String, dynamic> json) =>
      DashboardDailyQListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<DailyQDataForDashboard>.from(
                json["data"]!.map((x) => DailyQDataForDashboard.fromJson(x))),
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

class DailyQDataForDashboard {
  int? id;
  String? name;
  int? isChecked;
  String? newcheckid;

  DailyQDataForDashboard({
    this.id,
    this.name,
    this.isChecked,
    this.newcheckid,
  });

  factory DailyQDataForDashboard.fromJson(Map<String, dynamic> json) =>
      DailyQDataForDashboard(
        id: json["id"],
        name: json["name"],
        isChecked: json["is_checked"],
        newcheckid: json["newcheckid"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_checked": isChecked,
        "newcheckid": newcheckid,
      };
}
