// To parse this JSON data, do
//
//     final newsListModel = newsListModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/enterprise/enterprise_model.dart';

NewsListModel newsListModelFromJson(String str) =>
    NewsListModel.fromJson(json.decode(str));

String newsListModelToJson(NewsListModel data) => json.encode(data.toJson());

class NewsListModel {
  int? status;
  List<EnterpriseNews>? data;
  String? message;

  NewsListModel({
    this.status,
    this.data,
    this.message,
  });

  factory NewsListModel.fromJson(Map<String, dynamic> json) => NewsListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<EnterpriseNews>.from(
                json["data"]!.map((x) => EnterpriseNews.fromJson(x))),
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
