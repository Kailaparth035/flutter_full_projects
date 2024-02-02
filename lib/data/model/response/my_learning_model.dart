// To parse this JSON data, do
//
//     final myLearningModel = myLearningModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/courses_list_model.dart';

MyLearningModel myLearningModelFromJson(String str) =>
    MyLearningModel.fromJson(json.decode(str));

String myLearningModelToJson(MyLearningModel data) =>
    json.encode(data.toJson());

class MyLearningModel {
  int? status;
  List<MyLearningData>? data;
  String? message;

  MyLearningModel({
    this.status,
    this.data,
    this.message,
  });

  factory MyLearningModel.fromJson(Map<String, dynamic> json) =>
      MyLearningModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<MyLearningData>.from(
                json["data"]!.map((x) => MyLearningData.fromJson(x))),
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

class MyLearningData {
  String? title;
  List<Course>? courses;

  MyLearningData({
    this.title,
    this.courses,
  });

  factory MyLearningData.fromJson(Map<String, dynamic> json) => MyLearningData(
        title: json["title"],
        courses: json["courses"] == null
            ? []
            : List<Course>.from(
                json["courses"]!.map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "courses": courses == null
            ? []
            : List<dynamic>.from(courses!.map((x) => x.toJson())),
      };
}
