// To parse this JSON data, do
//
//     final followeCountModel = followeCountModelFromJson(jsonString);

import 'dart:convert';

FolloweCountModel followeCountModelFromJson(String str) =>
    FolloweCountModel.fromJson(json.decode(str));

String followeCountModelToJson(FolloweCountModel data) =>
    json.encode(data.toJson());

class FolloweCountModel {
  int? status;
  FolloweCountData? data;
  String? message;

  FolloweCountModel({
    this.status,
    this.data,
    this.message,
  });

  factory FolloweCountModel.fromJson(Map<String, dynamic> json) =>
      FolloweCountModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : FolloweCountData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class FolloweCountData {
  int? followerCount;

  FolloweCountData({
    this.followerCount,
  });

  factory FolloweCountData.fromJson(Map<String, dynamic> json) =>
      FolloweCountData(
        followerCount: json["follower_count"],
      );

  Map<String, dynamic> toJson() => {
        "follower_count": followerCount,
      };
}
