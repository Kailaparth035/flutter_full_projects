// To parse this JSON data, do
//
//     final workSkillSelfReflectDetailsModel = workSkillSelfReflectDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/slider_data_model.dart';

WorkSkillSelfReflectDetailsModel workSkillSelfReflectDetailsModelFromJson(
        String str) =>
    WorkSkillSelfReflectDetailsModel.fromJson(json.decode(str));

String workSkillSelfReflectDetailsModelToJson(
        WorkSkillSelfReflectDetailsModel data) =>
    json.encode(data.toJson());

class WorkSkillSelfReflectDetailsModel {
  int? status;
  WorkSkillSelfReflectDetailsData? data;
  String? message;

  WorkSkillSelfReflectDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory WorkSkillSelfReflectDetailsModel.fromJson(
          Map<String, dynamic> json) =>
      WorkSkillSelfReflectDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : WorkSkillSelfReflectDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class WorkSkillSelfReflectDetailsData {
  String? userId;
  int? ratingType;
  List<SliderList>? sliderList;
  List<dynamic>? radioList;
  List<dynamic>? checkboxList;

  WorkSkillSelfReflectDetailsData({
    this.userId,
    this.ratingType,
    this.sliderList,
    this.radioList,
    this.checkboxList,
  });

  factory WorkSkillSelfReflectDetailsData.fromJson(Map<String, dynamic> json) =>
      WorkSkillSelfReflectDetailsData(
        userId: json["user_id"],
        ratingType: json["rating_type"],
        sliderList: json["slider_list"] == null
            ? []
            : List<SliderList>.from(
                json["slider_list"]!.map((x) => SliderList.fromJson(x))),
        radioList: json["radio_list"] == null
            ? []
            : List<dynamic>.from(json["radio_list"]!.map((x) => x)),
        checkboxList: json["checkbox_list"] == null
            ? []
            : List<dynamic>.from(json["checkbox_list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "rating_type": ratingType,
        "slider_list": sliderList == null
            ? []
            : List<dynamic>.from(sliderList!.map((x) => x.toJson())),
        "radio_list": radioList == null
            ? []
            : List<dynamic>.from(radioList!.map((x) => x)),
        "checkbox_list": checkboxList == null
            ? []
            : List<dynamic>.from(checkboxList!.map((x) => x)),
      };
}

class SliderList {
  String? title;
  List<SliderData>? value;

  SliderList({
    this.title,
    this.value,
  });

  factory SliderList.fromJson(Map<String, dynamic> json) => SliderList(
        title: json["title"],
        value: json["value"] == null
            ? []
            : List<SliderData>.from(
                json["value"]!.map((x) => SliderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value == null
            ? []
            : List<dynamic>.from(value!.map((x) => x.toJson())),
      };
}
