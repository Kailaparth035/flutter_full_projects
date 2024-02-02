// To parse this JSON data, do
//
//     final organizationUserListModel = organizationUserListModelFromJson(jsonString);

import 'dart:convert';

OrganizationUserListModel organizationUserListModelFromJson(String str) =>
    OrganizationUserListModel.fromJson(json.decode(str));

String organizationUserListModelToJson(OrganizationUserListModel data) =>
    json.encode(data.toJson());

class OrganizationUserListModel {
  OrganizationUserListModel({
    this.status,
    this.data,
    this.message,
  });

  int? status;
  List<OrganizationUser>? data;
  String? message;

  factory OrganizationUserListModel.fromJson(Map<String, dynamic> json) =>
      OrganizationUserListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<OrganizationUser>.from(
                json["data"]!.map((x) => OrganizationUser.fromJson(x))),
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

class OrganizationUser {
  OrganizationUser({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory OrganizationUser.fromJson(Map<String, dynamic> json) =>
      OrganizationUser(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
