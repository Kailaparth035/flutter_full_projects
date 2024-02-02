// To parse this JSON data, do
//
//     final coacheeListModel = coacheeListModelFromJson(jsonString);

import 'dart:convert';

CoacheeListModel coacheeListModelFromJson(String str) =>
    CoacheeListModel.fromJson(json.decode(str));

String coacheeListModelToJson(CoacheeListModel data) =>
    json.encode(data.toJson());

class CoacheeListModel {
  int? status;
  List<CoacheeData>? data;
  String? message;

  CoacheeListModel({
    this.status,
    this.data,
    this.message,
  });

  factory CoacheeListModel.fromJson(Map<String, dynamic> json) =>
      CoacheeListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<CoacheeData>.from(
                json["data"]!.map((x) => CoacheeData.fromJson(x))),
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

class CoacheeData {
  int? id;
  String? name;
  String? positions;
  String? roleName;
  String? nameInitials;
  String? photo;

  CoacheeData({
    this.id,
    this.name,
    this.positions,
    this.roleName,
    this.nameInitials,
    this.photo,
  });

  factory CoacheeData.fromJson(Map<String, dynamic> json) => CoacheeData(
        id: json["id"],
        name: json["name"],
        positions: json["positions"],
        roleName: json["role_name"],
        nameInitials: json["name_initials"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "positions": positions,
        "role_name": roleName,
        "name_initials": nameInitials,
        "photo": photo,
      };
}
