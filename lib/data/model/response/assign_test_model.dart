// To parse this JSON data, do
//
//     final assignedTestsModel = assignedTestsModelFromJson(jsonString);

import 'dart:convert';

AssignedTestsModel assignedTestsModelFromJson(String str) =>
    AssignedTestsModel.fromJson(json.decode(str));

String assignedTestsModelToJson(AssignedTestsModel data) =>
    json.encode(data.toJson());

class AssignedTestsModel {
  int? status;
  List<AssignedTestsData>? data;
  String? message;

  AssignedTestsModel({
    this.status,
    this.data,
    this.message,
  });

  factory AssignedTestsModel.fromJson(Map<String, dynamic> json) =>
      AssignedTestsModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<AssignedTestsData>.from(
                json["data"]!.map((x) => AssignedTestsData.fromJson(x))),
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

class AssignedTestsData {
  int? id;
  String? titleName;
  String? url;

  AssignedTestsData({
    this.id,
    this.titleName,
    this.url,
  });

  factory AssignedTestsData.fromJson(Map<String, dynamic> json) =>
      AssignedTestsData(
        id: json["id"],
        titleName: json["title_name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title_name": titleName,
        "url": url,
      };
}
