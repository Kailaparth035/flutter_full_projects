// To parse this JSON data, do
//
//     final badgeListModel = badgeListModelFromJson(jsonString);

import 'dart:convert';

BadgeListModel badgeListModelFromJson(String str) =>
    BadgeListModel.fromJson(json.decode(str));

String badgeListModelToJson(BadgeListModel data) => json.encode(data.toJson());

class BadgeListModel {
  int? status;
  List<BadgeData>? data;
  String? message;

  BadgeListModel({
    this.status,
    this.data,
    this.message,
  });

  factory BadgeListModel.fromJson(Map<String, dynamic> json) => BadgeListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<BadgeData>.from(
                json["data"]!.map((x) => BadgeData.fromJson(x))),
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

class BadgeData {
  int? id;
  int? productId;
  String? productName;
  String? productPath;

  BadgeData({
    this.id,
    this.productId,
    this.productName,
    this.productPath,
  });

  factory BadgeData.fromJson(Map<String, dynamic> json) => BadgeData(
        id: json["id"],
        productId: json["product_id"],
        productName: json["product_name"],
        productPath: json["product_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "product_name": productName,
        "product_path": productPath,
      };
}
