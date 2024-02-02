// To parse this JSON data, do
//
//     final actionItemsModel = actionItemsModelFromJson(jsonString);

import 'dart:convert';

ActionItemsModel actionItemsModelFromJson(String str) =>
    ActionItemsModel.fromJson(json.decode(str));

String actionItemsModelToJson(ActionItemsModel data) =>
    json.encode(data.toJson());

class ActionItemsModel {
  int? status;
  List<ActionItemsData>? data;
  String? message;

  ActionItemsModel({
    this.status,
    this.data,
    this.message,
  });

  factory ActionItemsModel.fromJson(Map<String, dynamic> json) =>
      ActionItemsModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<ActionItemsData>.from(
                json["data"]!.map((x) => ActionItemsData.fromJson(x))),
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

class ActionItemsData {
  String? fullName;
  String? photo;
  String? startDate;
  String? endDate;
  String? linkText;
  String? linkUrl;
  String? status;
  String? useFor;

  String? openTypeMsg;

  String? styleId;
  String? userId;
  String? tabName;
  String? userType;
  OpenType? openType;
  int? isShowElarning;

  ActionItemsData(
      {this.fullName,
      this.photo,
      this.startDate,
      this.endDate,
      this.linkText,
      this.linkUrl,
      this.status,
      this.useFor,
      this.openType,
      this.openTypeMsg,
      this.styleId,
      this.userId,
      this.tabName,
      this.userType,
      this.isShowElarning});

  factory ActionItemsData.fromJson(Map<String, dynamic> json) =>
      ActionItemsData(
        fullName: json["full_name"],
        photo: json["photo"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        linkText: json["link_text"],
        linkUrl: json["link_url"],
        status: json["status"],
        useFor: json["use_for"],
        openType: openTypeValues.map[json["open_type"]]!,
        openTypeMsg: json["open_type_msg"],
        styleId: json["style_id"]?.toString(),
        userId: json["user_id"]?.toString(),
        tabName: json["tab_name"],
        userType: json["user_type"],
        isShowElarning: json["is_elearning_show"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "photo": photo,
        "start_date": startDate,
        "end_date": endDate,
        "link_text": linkText,
        "link_url": linkUrl,
        "status": status,
        "use_for": useFor,
        "open_type": openTypeValues.reverse[openType],
        "open_type_msg": openTypeMsg,
        "style_id": styleId,
        "user_id": userId,
        "tab_name": tabName,
        "user_type": userType,
      };
}

enum OpenType { empty, external, internal }

final openTypeValues = EnumValues({
  "": OpenType.empty,
  "external": OpenType.external,
  "internal": OpenType.internal
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
