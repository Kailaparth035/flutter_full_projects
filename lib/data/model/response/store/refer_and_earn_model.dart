// To parse this JSON data, do
//
//     final referAndEarnModel = referAndEarnModelFromJson(jsonString);

import 'dart:convert';

ReferAndEarnModel referAndEarnModelFromJson(String str) =>
    ReferAndEarnModel.fromJson(json.decode(str));

String referAndEarnModelToJson(ReferAndEarnModel data) =>
    json.encode(data.toJson());

class ReferAndEarnModel {
  int? status;
  ReferAndEarnData? data;
  String? message;

  ReferAndEarnModel({
    this.status,
    this.data,
    this.message,
  });

  factory ReferAndEarnModel.fromJson(Map<String, dynamic> json) =>
      ReferAndEarnModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : ReferAndEarnData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class ReferAndEarnData {
  String? earnAmount;
  String? referalCode;
  String? referalSubject;
  String? referalText;
  List<String>? stepList;

  ReferAndEarnData({
    this.earnAmount,
    this.referalCode,
    this.referalSubject,
    this.referalText,
    this.stepList,
  });

  factory ReferAndEarnData.fromJson(Map<String, dynamic> json) =>
      ReferAndEarnData(
        earnAmount: json["earn_amount"],
        referalCode: json["referal_code"],
        referalSubject: json["referal_subject"],
        referalText: json["referal_text"],
        stepList: json["step_list"] == null
            ? []
            : List<String>.from(json["step_list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "earn_amount": earnAmount,
        "referal_code": referalCode,
        "referal_subject": referalSubject,
        "referal_text": referalText,
        "step_list":
            stepList == null ? [] : List<dynamic>.from(stepList!.map((x) => x)),
      };
}
