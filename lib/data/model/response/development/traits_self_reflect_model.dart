// To parse this JSON data, do
//
//     final traitsSelfReflectDetailsModel = traitsSelfReflectDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/slider_data_model.dart';

TraitsSelfReflectDetailsModel traitsSelfReflectDetailsModelFromJson(
        String str) =>
    TraitsSelfReflectDetailsModel.fromJson(json.decode(str));

String traitsSelfReflectDetailsModelToJson(
        TraitsSelfReflectDetailsModel data) =>
    json.encode(data.toJson());

class TraitsSelfReflectDetailsModel {
  int? status;
  TraitsSelfReflectDetailsData? data;
  String? message;

  TraitsSelfReflectDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory TraitsSelfReflectDetailsModel.fromJson(Map<String, dynamic> json) =>
      TraitsSelfReflectDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : TraitsSelfReflectDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class TraitsSelfReflectDetailsData {
  String? userId;
  String? text;
  int? ratingType;
  List<SliderData>? sliderList;
  List<dynamic>? radioList;
  List<dynamic>? checkboxList;
  List<dynamic>? reflectCheckboxList;

  TraitsSelfReflectDetailsData({
    this.userId,
    this.text,
    this.ratingType,
    this.sliderList,
    this.radioList,
    this.checkboxList,
    this.reflectCheckboxList,
  });

  factory TraitsSelfReflectDetailsData.fromJson(Map<String, dynamic> json) =>
      TraitsSelfReflectDetailsData(
        userId: json["user_id"],
        text: json["text"],
        ratingType: json["rating_type"],
        sliderList: json["slider_list"] == null
            ? []
            : List<SliderData>.from(
                json["slider_list"]!.map((x) => SliderData.fromJson(x))),
        radioList: json["radio_list"] == null
            ? []
            : List<dynamic>.from(json["radio_list"]!.map((x) => x)),
        checkboxList: json["checkbox_list"] == null
            ? []
            : List<dynamic>.from(json["checkbox_list"]!.map((x) => x)),
        reflectCheckboxList: json["reflect_checkbox_list"] == null
            ? []
            : List<dynamic>.from(json["reflect_checkbox_list"]!.map((x) => x)),
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
        "reflect_checkbox_list": reflectCheckboxList == null
            ? []
            : List<dynamic>.from(reflectCheckboxList!.map((x) => x)),
      };
}
