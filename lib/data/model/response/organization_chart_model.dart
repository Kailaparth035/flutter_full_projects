// To parse this JSON data, do
//
//     final OrganizationChartModel = OrganizationChartModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/util/colors.dart';
import 'package:flutter/material.dart';

OrganizationChartModel organizationChartModelFromJson(String str) =>
    OrganizationChartModel.fromJson(json.decode(str));

String organizationChartModelToJson(OrganizationChartModel data) =>
    json.encode(data.toJson());

class OrganizationChartModel {
  OrganizationChartModel({
    this.status,
    this.data,
    this.message,
  });

  int? status;
  List<OrganizarionChartData>? data;
  String? message;

  factory OrganizationChartModel.fromJson(Map<String, dynamic> json) =>
      OrganizationChartModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<OrganizarionChartData>.from(
                json["data"]!.map((x) => OrganizarionChartData.fromJson(x))),
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

class OrganizarionChartData {
  OrganizarionChartData({
    this.id,
    this.type,
    this.name,
    this.photo,
    this.email,
    this.companyId,
    this.phone,
    this.positionName,
    this.nameInitials,
    this.directReportCount,
    this.color,
    this.child,
  });

  int? id;
  String? type;
  String? name;
  String? photo;
  String? email;
  int? companyId;
  String? phone;
  String? positionName;
  String? nameInitials;
  int? directReportCount;
  List<OrganizarionChartData>? child;
  Color? color;

  factory OrganizarionChartData.fromJson(Map<String, dynamic> json) =>
      OrganizarionChartData(
        id: json["id"],
        type: json["type"],
        name: json["name"],
        photo: json["photo"],
        email: json["email"],
        companyId: json["company_id"],
        phone: json["phone"],
        positionName: json["position_name"],
        nameInitials: json["name_initials"],
        directReportCount: json["direct_report_count"],
        color: _getColors(json["type"]),
        child: json["child"] == null
            ? []
            : List<OrganizarionChartData>.from(
                json["child"]!.map((x) => OrganizarionChartData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "photo": photo,
        "email": email,
        "company_id": companyId,
        "phone": phone,
        "position_name": positionName,
        "name_initials": nameInitials,
        "direct_report_count": directReportCount,
        "child": child == null
            ? []
            : List<dynamic>.from(child!.map((x) => x.toJson())),
      };

  static Color _getColors(type) {
    if (type == "parent") {
      return AppColors.secondaryColor;
    } else if (type == "middle") {
      return AppColors.primaryColor;
    } else {
      return AppColors.greenColor;
    }
  }
}
