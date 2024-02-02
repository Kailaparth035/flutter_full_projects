// To parse this JSON data, do
//
//     final myMentorsListModel = myMentorsListModelFromJson(jsonString);

import 'dart:convert';

MyMentorsListModel myMentorsListModelFromJson(String str) =>
    MyMentorsListModel.fromJson(json.decode(str));

String myMentorsListModelToJson(MyMentorsListModel data) =>
    json.encode(data.toJson());

class MyMentorsListModel {
  int? status;
  List<MyMentorsData>? data;
  String? message;

  MyMentorsListModel({
    this.status,
    this.data,
    this.message,
  });

  factory MyMentorsListModel.fromJson(Map<String, dynamic> json) =>
      MyMentorsListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<MyMentorsData>.from(
                json["data"]!.map((x) => MyMentorsData.fromJson(x))),
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

class MyMentorsData {
  int? id;
  String? name;
  String? photo;
  int? companyId;
  String? positions;
  String? roleName;
  String? nameInitials;
  String? connect;
  String? agreement;
  String? schedule;
  String? email;

  MyMentorsData(
      {this.id,
      this.name,
      this.photo,
      this.companyId,
      this.positions,
      this.roleName,
      this.nameInitials,
      this.connect,
      this.agreement,
      this.email,
      this.schedule});

  factory MyMentorsData.fromJson(Map<String, dynamic> json) => MyMentorsData(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
        companyId: json["company_id"],
        positions: json["positions"],
        roleName: json["role_name"],
        nameInitials: json["name_initials"],
        connect: json["connect"],
        agreement: json["agreement"],
        schedule: json["schedule"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "company_id": companyId,
        "positions": positions,
        "role_name": roleName,
        "name_initials": nameInitials,
        "connect": connect,
        "agreement": agreement,
        "email": email,
      };
}
