// To parse this JSON data, do
//
//     final dailyQHistoryModel = dailyQHistoryModelFromJson(jsonString);

import 'dart:convert';

DailyQHistoryModel dailyQHistoryModelFromJson(String str) =>
    DailyQHistoryModel.fromJson(json.decode(str));

String dailyQHistoryModelToJson(DailyQHistoryModel data) =>
    json.encode(data.toJson());

class DailyQHistoryModel {
  int? status;
  List<DailyQData>? data;
  String? message;

  DailyQHistoryModel({
    this.status,
    this.data,
    this.message,
  });

  factory DailyQHistoryModel.fromJson(Map<String, dynamic> json) =>
      DailyQHistoryModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<DailyQData>.from(
                json["data"]!.map((x) => DailyQData.fromJson(x))),
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

class DailyQData {
  int? finalScore;
  String? finalDate;

  DailyQData({
    this.finalScore,
    this.finalDate,
  });

  factory DailyQData.fromJson(Map<String, dynamic> json) => DailyQData(
        finalScore: json["finalScore"],
        finalDate: json["finalDate"],
      );

  Map<String, dynamic> toJson() => {
        "finalScore": finalScore,
        "finalDate": finalDate,
      };
}
