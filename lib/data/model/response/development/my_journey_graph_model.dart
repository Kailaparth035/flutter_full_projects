// To parse this JSON data, do
//
//     final myJourneyGrowthChartModel = myJourneyGrowthChartModelFromJson(jsonString);

import 'dart:convert';

MyJourneyGrowthChartModel myJourneyGrowthChartModelFromJson(String str) =>
    MyJourneyGrowthChartModel.fromJson(json.decode(str));

String myJourneyGrowthChartModelToJson(MyJourneyGrowthChartModel data) =>
    json.encode(data.toJson());

class MyJourneyGrowthChartModel {
  int? status;
  MyJourneyGrowthChartData? data;
  String? message;

  MyJourneyGrowthChartModel({
    this.status,
    this.data,
    this.message,
  });

  factory MyJourneyGrowthChartModel.fromJson(Map<String, dynamic> json) =>
      MyJourneyGrowthChartModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : MyJourneyGrowthChartData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class MyJourneyGrowthChartData {
  String? graphType;
  String? userId;
  String? relationWithLoginUser;
  List<ChartData>? chartData;

  MyJourneyGrowthChartData({
    this.graphType,
    this.userId,
    this.relationWithLoginUser,
    this.chartData,
  });

  factory MyJourneyGrowthChartData.fromJson(Map<String, dynamic> json) =>
      MyJourneyGrowthChartData(
        graphType: json["graph_type"],
        userId: json["user_id"],
        relationWithLoginUser: json["relation_with_loginUser"],
        chartData: json["chart_data"] == null
            ? []
            : List<ChartData>.from(
                json["chart_data"]!.map((x) => ChartData.fromJson(x))),
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

class ChartData {
  String? label;
  int? journeyCount;

  ChartData({
    this.label,
    this.journeyCount,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
        label: json["label"],
        journeyCount: json["journey_count"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "journey_count": journeyCount,
      };
}
