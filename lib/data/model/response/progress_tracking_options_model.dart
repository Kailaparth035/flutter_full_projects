// To parse this JSON data, do
//
//     final progressTrackingOptionModel = progressTrackingOptionModelFromJson(jsonString);

import 'dart:convert';

ProgressTrackingOptionModel progressTrackingOptionModelFromJson(String str) =>
    ProgressTrackingOptionModel.fromJson(json.decode(str));

String progressTrackingOptionModelToJson(ProgressTrackingOptionModel data) =>
    json.encode(data.toJson());

class ProgressTrackingOptionModel {
  int? status;
  List<ProgressTrackingOptionData>? data;
  String? message;

  ProgressTrackingOptionModel({
    this.status,
    this.data,
    this.message,
  });

  factory ProgressTrackingOptionModel.fromJson(Map<String, dynamic> json) =>
      ProgressTrackingOptionModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<ProgressTrackingOptionData>.from(json["data"]!
                .map((x) => ProgressTrackingOptionData.fromJson(x))),
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

class ProgressTrackingOptionData {
  String? title;
  String? value;

  ProgressTrackingOptionData({
    this.title,
    this.value,
  });

  factory ProgressTrackingOptionData.fromJson(Map<String, dynamic> json) =>
      ProgressTrackingOptionData(
        title: json["title"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
      };
}
