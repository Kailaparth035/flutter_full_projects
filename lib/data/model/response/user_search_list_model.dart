// To parse this JSON data, do
//
//     final peopleUserListModel = peopleUserListModelFromJson(jsonString);

import 'dart:convert';

PeopleUserListModel peopleUserListModelFromJson(String str) =>
    PeopleUserListModel.fromJson(json.decode(str));

String peopleUserListModelToJson(PeopleUserListModel data) =>
    json.encode(data.toJson());

class PeopleUserListModel {
  int? status;
  List<PeopleUserData>? data;
  String? message;

  PeopleUserListModel({
    this.status,
    this.data,
    this.message,
  });

  factory PeopleUserListModel.fromJson(Map<String, dynamic> json) =>
      PeopleUserListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<PeopleUserData>.from(
                json["data"]!.map((x) => PeopleUserData.fromJson(x))),
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

class PeopleUserData {
  int? id;
  String? name;

  PeopleUserData({
    this.id,
    this.name,
  });

  factory PeopleUserData.fromJson(Map<String, dynamic> json) => PeopleUserData(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
