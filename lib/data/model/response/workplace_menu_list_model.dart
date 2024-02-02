// To parse this JSON data, do
//
//     final workplaceMenuListModel = workplaceMenuListModelFromJson(jsonString);

import 'dart:convert';

WorkplaceMenuListModel workplaceMenuListModelFromJson(String str) =>
    WorkplaceMenuListModel.fromJson(json.decode(str));

String workplaceMenuListModelToJson(WorkplaceMenuListModel data) =>
    json.encode(data.toJson());

class WorkplaceMenuListModel {
  int? status;
  WorkplaceMenuData? data;
  String? message;

  WorkplaceMenuListModel({
    this.status,
    this.data,
    this.message,
  });

  factory WorkplaceMenuListModel.fromJson(Map<String, dynamic> json) =>
      WorkplaceMenuListModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : WorkplaceMenuData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class WorkplaceMenuData {
  String? organizationChart;
  String? supervisors;
  String? peers;
  String? directReports;
  String? community;
  String? coaches;
  String? mentors;
  String? mentees;

  WorkplaceMenuData({
    this.organizationChart,
    this.supervisors,
    this.peers,
    this.directReports,
    this.community,
    this.coaches,
    this.mentors,
    this.mentees,
  });

  factory WorkplaceMenuData.fromJson(Map<String, dynamic> json) =>
      WorkplaceMenuData(
        organizationChart: json["OrganizationChart"] ?? "Yes",
        supervisors: json["Supervisors"],
        peers: json["Peers"],
        directReports: json["DirectReports"],
        community: json["Community"],
        coaches: json["Coaches"],
        mentors: json["Mentors"],
        mentees: json["Mentees"],
      );

  Map<String, dynamic> toJson() => {
        "OrganizationChart": organizationChart,
        "Supervisors": supervisors,
        "Peers": peers,
        "DirectReports": directReports,
        "Community": community,
        "Coaches": coaches,
        "Mentors": mentors,
        "Mentees": mentees,
      };
}
