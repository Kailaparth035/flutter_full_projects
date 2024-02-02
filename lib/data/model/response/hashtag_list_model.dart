// To parse this JSON data, do
//
//     final hashTagListModel = hashTagListModelFromJson(jsonString);

import 'dart:convert';

HashTagListModel hashTagListModelFromJson(String str) =>
    HashTagListModel.fromJson(json.decode(str));

String hashTagListModelToJson(HashTagListModel data) =>
    json.encode(data.toJson());

class HashTagListModel {
  int? status;
  List<HashtagData>? data;
  String? message;

  HashTagListModel({
    this.status,
    this.data,
    this.message,
  });

  factory HashTagListModel.fromJson(Map<String, dynamic> json) =>
      HashTagListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<HashtagData>.from(
                json["data"]!.map((x) => HashtagData.fromJson(x))),
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

class HashtagData {
  int? id;
  String? name;
  String? image;
  String? title;
  bool isFollowed;
  bool isChecked;

  HashtagData({
    this.id,
    this.name,
    this.image,
    this.title,
    this.isFollowed = false,
    this.isChecked = false,
  });

  factory HashtagData.fromJson(Map<String, dynamic> json) => HashtagData(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        isFollowed: json["is_checked"] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
