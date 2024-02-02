// To parse this JSON data, do
//
//     final behaviorSelfReflectDetailsModel = behaviorSelfReflectDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/slider_data_model.dart';

BehaviorSelfReflectDetailsModel behaviorSelfReflectDetailsModelFromJson(
        String str) =>
    BehaviorSelfReflectDetailsModel.fromJson(json.decode(str));

String behaviorSelfReflectDetailsModelToJson(
        BehaviorSelfReflectDetailsModel data) =>
    json.encode(data.toJson());

class BehaviorSelfReflectDetailsModel {
  int? status;
  BehaviorSelfReflectDetailsData? data;
  String? message;

  BehaviorSelfReflectDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory BehaviorSelfReflectDetailsModel.fromJson(Map<String, dynamic> json) =>
      BehaviorSelfReflectDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : BehaviorSelfReflectDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class BehaviorSelfReflectDetailsData {
  String? userId;
  int? ratingType;
  List<dynamic>? sliderList;
  List<dynamic>? radioList;
  List<SliderData>? checkboxList;
  List<dynamic>? reflectCheckboxList;

  BehaviorSelfReflectDetailsData({
    this.userId,
    this.ratingType,
    this.sliderList,
    this.radioList,
    this.checkboxList,
    this.reflectCheckboxList,
  });

  factory BehaviorSelfReflectDetailsData.fromJson(Map<String, dynamic> json) =>
      BehaviorSelfReflectDetailsData(
        userId: json["user_id"],
        ratingType: json["rating_type"],
        sliderList: json["slider_list"] == null
            ? []
            : List<dynamic>.from(json["slider_list"]!.map((x) => x)),
        radioList: json["radio_list"] == null
            ? []
            : List<dynamic>.from(json["radio_list"]!.map((x) => x)),
        checkboxList: json["checkbox_list"] == null
            ? []
            : List<SliderData>.from(
                json["checkbox_list"]!.map((x) => SliderData.fromJson(x))),
        reflectCheckboxList: json["reflect_checkbox_list"] == null
            ? []
            : List<dynamic>.from(json["reflect_checkbox_list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "rating_type": ratingType,
        "slider_list": sliderList == null
            ? []
            : List<dynamic>.from(sliderList!.map((x) => x)),
        "radio_list": radioList == null
            ? []
            : List<dynamic>.from(radioList!.map((x) => x)),
        "checkbox_list": checkboxList == null
            ? []
            : List<dynamic>.from(checkboxList!.map((x) => x.toJson())),
        "reflect_checkbox_list": reflectCheckboxList == null
            ? []
            : List<dynamic>.from(reflectCheckboxList!.map((x) => x)),
      };
}
