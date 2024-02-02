// To parse this JSON data, do
//
//     final emotionGraphModel = emotionGraphModelFromJson(jsonString);

import 'dart:convert';

EmotionGraphModel emotionGraphModelFromJson(String str) =>
    EmotionGraphModel.fromJson(json.decode(str));

String emotionGraphModelToJson(EmotionGraphModel data) =>
    json.encode(data.toJson());

class EmotionGraphModel {
  int? status;
  EmotionGraphData? data;
  String? message;

  EmotionGraphModel({
    this.status,
    this.data,
    this.message,
  });

  factory EmotionGraphModel.fromJson(Map<String, dynamic> json) =>
      EmotionGraphModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : EmotionGraphData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class EmotionGraphData {
  String? graphType;
  String? userId;
  String? relationWithLoginUser;
  List<ChartDatum>? chartData;

  EmotionGraphData({
    this.graphType,
    this.userId,
    this.relationWithLoginUser,
    this.chartData,
  });

  factory EmotionGraphData.fromJson(Map<String, dynamic> json) =>
      EmotionGraphData(
        graphType: json["graph_type"],
        userId: json["user_id"],
        relationWithLoginUser: json["relation_with_loginUser"],
        chartData: json["chart_data"] == null
            ? []
            : List<ChartDatum>.from(
                json["chart_data"]!.map((x) => ChartDatum.fromJson(x))),
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

class ChartDatum {
  String? label;
  int? positive;
  int? negative;

  ChartDatum({
    this.label,
    this.positive,
    this.negative,
  });

  factory ChartDatum.fromJson(Map<String, dynamic> json) => ChartDatum(
        label: json["label"],
        positive: json["positive"],
        negative: json["negative"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "positive": positive,
        "negative": negative,
      };
}
