// To parse this JSON data, do
//
//     final badgeLegendPopupModel = badgeLegendPopupModelFromJson(jsonString);

import 'dart:convert';

BadgeLegendPopupModel badgeLegendPopupModelFromJson(String str) =>
    BadgeLegendPopupModel.fromJson(json.decode(str));

String badgeLegendPopupModelToJson(BadgeLegendPopupModel data) =>
    json.encode(data.toJson());

class BadgeLegendPopupModel {
  int? status;
  BadgeLegendPopupData? data;
  String? message;

  BadgeLegendPopupModel({
    this.status,
    this.data,
    this.message,
  });

  factory BadgeLegendPopupModel.fromJson(Map<String, dynamic> json) =>
      BadgeLegendPopupModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : BadgeLegendPopupData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class BadgeLegendPopupData {
  String? popupTitle;
  String? descriptionTitle;
  List<MainList>? mainList;

  BadgeLegendPopupData({
    this.popupTitle,
    this.descriptionTitle,
    this.mainList,
  });

  factory BadgeLegendPopupData.fromJson(Map<String, dynamic> json) =>
      BadgeLegendPopupData(
        popupTitle: json["popup_title"],
        descriptionTitle: json["description_title"],
        mainList: json["main_list"] == null
            ? []
            : List<MainList>.from(
                json["main_list"]!.map((x) => MainList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "popup_title": popupTitle,
        "description_title": descriptionTitle,
        "main_list": mainList == null
            ? []
            : List<dynamic>.from(mainList!.map((x) => x.toJson())),
      };
}

class MainList {
  String? title;
  String? count;
  List<BadgeData>? badgeList;
  List<String>? description;

  MainList({
    this.title,
    this.count,
    this.badgeList,
    this.description,
  });

  factory MainList.fromJson(Map<String, dynamic> json) => MainList(
        title: json["title"],
        count: json["count"]?.toString(),
        badgeList: json["badge_list"] == null
            ? []
            : List<BadgeData>.from(
                json["badge_list"]!.map((x) => BadgeData.fromJson(x))),
        description: json["description"] == null
            ? []
            : List<String>.from(json["description"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "count": count,
        "badge_list": badgeList == null
            ? []
            : List<dynamic>.from(badgeList!.map((x) => x.toJson())),
        "description": description == null
            ? []
            : List<dynamic>.from(description!.map((x) => x)),
      };
}

class BadgeData {
  String? name;
  String? point;
  String? isSelected;
  String? image;

  BadgeData({
    this.name,
    this.point,
    this.isSelected,
    this.image,
  });

  factory BadgeData.fromJson(Map<String, dynamic> json) => BadgeData(
        name: json["name"],
        point: json["point"],
        isSelected: json["is_selected"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "point": point,
        "is_selected": isSelected,
        "image": image,
      };
}
