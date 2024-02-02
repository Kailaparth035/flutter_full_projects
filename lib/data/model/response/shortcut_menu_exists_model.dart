// To parse this JSON data, do
//
//     final shortCutMenuExistModel = shortCutMenuExistModelFromJson(jsonString);

import 'dart:convert';

ShortCutMenuExistModel shortCutMenuExistModelFromJson(String str) =>
    ShortCutMenuExistModel.fromJson(json.decode(str));

String shortCutMenuExistModelToJson(ShortCutMenuExistModel data) =>
    json.encode(data.toJson());

class ShortCutMenuExistModel {
  int? status;
  ShortCutMenuExistData? data;
  String? message;

  ShortCutMenuExistModel({
    this.status,
    this.data,
    this.message,
  });

  factory ShortCutMenuExistModel.fromJson(Map<String, dynamic> json) =>
      ShortCutMenuExistModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : ShortCutMenuExistData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class ShortCutMenuExistData {
  int? developmentMenu;
  int? mycoachMenu;
  int? isShowReferAndEarnMenu;
  ShortCutMenuExistData({
    this.developmentMenu,
    this.mycoachMenu,
    this.isShowReferAndEarnMenu,
  });

  factory ShortCutMenuExistData.fromJson(Map<String, dynamic> json) =>
      ShortCutMenuExistData(
        developmentMenu: json["development_menu"],
        mycoachMenu: json["mycoach_menu"],
        isShowReferAndEarnMenu: json["is_show_refer_and_earn_menu"],
      );

  Map<String, dynamic> toJson() => {
        "development_menu": developmentMenu,
        "mycoach_menu": mycoachMenu,
        "is_show_refer_and_earn_menu": isShowReferAndEarnMenu,
      };
}
