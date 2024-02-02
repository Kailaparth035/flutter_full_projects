// To parse this JSON data, do
//
//     final myconnectionUserListModel = myconnectionUserListModelFromJson(jsonString);

import 'dart:convert';

MyconnectionUserListModel myconnectionUserListModelFromJson(String str) =>
    MyconnectionUserListModel.fromJson(json.decode(str));

String myconnectionUserListModelToJson(MyconnectionUserListModel data) =>
    json.encode(data.toJson());

class MyconnectionUserListModel {
  MyconnectionUserListModel({
    this.status,
    this.data,
    this.message,
  });

  int? status;
  List<MyConnectionUserListData>? data;
  String? message;

  factory MyconnectionUserListModel.fromJson(Map<String, dynamic> json) =>
      MyconnectionUserListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<MyConnectionUserListData>.from(
                json["data"]!.map((x) => MyConnectionUserListData.fromJson(x))),
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

class MyConnectionUserListData {
  MyConnectionUserListData(
      {this.id,
      this.name,
      this.photo,
      this.companyId,
      this.positionName,
      this.roleName,
      this.nameInitials,
      this.assessbadges,
      this.isShowDevelopment});

  int? id;
  String? name;
  String? photo;
  int? companyId;
  String? positionName;
  String? roleName;
  String? nameInitials;
  String? assessbadges;
  String? isShowDevelopment;

  factory MyConnectionUserListData.fromJson(Map<String, dynamic> json) =>
      MyConnectionUserListData(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
        companyId: json["company_id"],
        positionName: json["position_name"],
        roleName: json["role_name"],
        nameInitials: json["name_initials"],
        assessbadges: json["assess_badges"] == null
            ? ""
            : json["assess_badges"].toString(),
        isShowDevelopment: json["is_show_development"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "company_id": companyId,
        "position_name": positionName,
        "role_name": roleName,
        "name_initials": nameInitials,
        "assess_badges": assessbadges,
      };
}
