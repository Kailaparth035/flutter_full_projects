// To parse this JSON data, do
//
//     final progressTrakingChartModel = progressTrakingChartModelFromJson(jsonString);

import 'dart:convert';

ProgressTrakingChartModel progressTrakingChartModelFromJson(String str) =>
    ProgressTrakingChartModel.fromJson(json.decode(str));

String progressTrakingChartModelToJson(ProgressTrakingChartModel data) =>
    json.encode(data.toJson());

class ProgressTrakingChartModel {
  int? status;
  ProgressTrakingChartData? data;
  String? message;

  ProgressTrakingChartModel({
    this.status,
    this.data,
    this.message,
  });

  factory ProgressTrakingChartModel.fromJson(Map<String, dynamic> json) =>
      ProgressTrakingChartModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : ProgressTrakingChartData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class ProgressTrakingChartData {
  String? graphType;
  String? userId;
  String? relationWithLoginUser;
  List<ProgressChartData>? chartData;

  ProgressTrakingChartData({
    this.graphType,
    this.userId,
    this.relationWithLoginUser,
    this.chartData,
  });

  factory ProgressTrakingChartData.fromJson(Map<String, dynamic> json) =>
      ProgressTrakingChartData(
        graphType: json["graph_type"],
        userId: json["user_id"],
        relationWithLoginUser: json["relation_with_loginUser"],
        chartData: json["chart_data"] == null
            ? []
            : List<ProgressChartData>.from(
                json["chart_data"]!.map((x) => ProgressChartData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "graph_type": graphType,
        "user_id": userId,
        "relation_with_loginUser": relationWithLoginUser,
        "chart_data": chartData == null
            ? []
            : List<dynamic>.from(chartData!.map((x) => x.toJson())),
      };
}

class ProgressChartData {
  String? label;
  String? journeyCount;

  ProgressChartData({
    this.label,
    this.journeyCount,
  });

  factory ProgressChartData.fromJson(Map<String, dynamic> json) =>
      ProgressChartData(
        label: json["label"],
        journeyCount: json["tracking_count"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "tracking_count": journeyCount,
      };
}
