// To parse this JSON data, do
//
//     final integrationSettingModel = integrationSettingModelFromJson(jsonString);

import 'dart:convert';

IntegrationSettingModel integrationSettingModelFromJson(String str) =>
    IntegrationSettingModel.fromJson(json.decode(str));

String integrationSettingModelToJson(IntegrationSettingModel data) =>
    json.encode(data.toJson());

class IntegrationSettingModel {
  int? status;
  IntegrationSettingData? data;
  String? message;

  IntegrationSettingModel({
    this.status,
    this.data,
    this.message,
  });

  factory IntegrationSettingModel.fromJson(Map<String, dynamic> json) =>
      IntegrationSettingModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : IntegrationSettingData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class IntegrationSettingData {
  String? calendarIntegration;
  String? emailIntegration;
  String? slackIntegration;
  String? googleContact;

  IntegrationSettingData({
    this.calendarIntegration,
    this.emailIntegration,
    this.slackIntegration,
    this.googleContact,
  });

  factory IntegrationSettingData.fromJson(Map<String, dynamic> json) =>
      IntegrationSettingData(
        calendarIntegration: json["calendar_integration"].toString(),
        emailIntegration: json["email_integration"].toString(),
        slackIntegration: json["slack_integration"].toString(),
        googleContact: json["google_contact"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "calendar_integration": calendarIntegration,
        "email_integration": emailIntegration,
        "slack_integration": slackIntegration,
        "google_contact": googleContact,
      };
}
