// To parse this JSON data, do
//
//     final commonDataModel = commonDataModelFromJson(jsonString);

import 'dart:convert';

CommonDataModel commonDataModelFromJson(String str) =>
    CommonDataModel.fromJson(json.decode(str));

String commonDataModelToJson(CommonDataModel data) =>
    json.encode(data.toJson());

class CommonDataModel {
  int? status;
  CommonData? data;
  String? message;

  CommonDataModel({
    this.status,
    this.data,
    this.message,
  });

  factory CommonDataModel.fromJson(Map<String, dynamic> json) =>
      CommonDataModel(
        status: json["status"],
        data: json["data"] == null ? null : CommonData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class CommonData {
  List<SupportScreenDropdownOption>? supportScreenDropdownOptions;
  int? notificationCount;

  CommonData({
    this.supportScreenDropdownOptions,
    this.notificationCount,
  });

  factory CommonData.fromJson(Map<String, dynamic> json) => CommonData(
        supportScreenDropdownOptions:
            json["support_screen_dropdown_options"] == null
                ? []
                : List<SupportScreenDropdownOption>.from(
                    json["support_screen_dropdown_options"]!
                        .map((x) => SupportScreenDropdownOption.fromJson(x))),
        notificationCount: json["notification_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "support_screen_dropdown_options": supportScreenDropdownOptions == null
            ? []
            : List<dynamic>.from(
                supportScreenDropdownOptions!.map((x) => x.toJson())),
      };
}

class SupportScreenDropdownOption {
  String? id;
  String? value;

  SupportScreenDropdownOption({
    this.id,
    this.value,
  });

  factory SupportScreenDropdownOption.fromJson(Map<String, dynamic> json) =>
      SupportScreenDropdownOption(
        id: json["id"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
      };
}
