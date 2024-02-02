// To parse this JSON data, do
//
//     final riskFactorSelfReflectDetailsModel = riskFactorSelfReflectDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/slider_data_model.dart';

RiskFactorSelfReflectDetailsModel riskFactorSelfReflectDetailsModelFromJson(
        String str) =>
    RiskFactorSelfReflectDetailsModel.fromJson(json.decode(str));

String riskFactorSelfReflectDetailsModelToJson(
        RiskFactorSelfReflectDetailsModel data) =>
    json.encode(data.toJson());

class RiskFactorSelfReflectDetailsModel {
  int? status;
  RiskFactorSelfReflectDetailsData? data;
  String? message;

  RiskFactorSelfReflectDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory RiskFactorSelfReflectDetailsModel.fromJson(
          Map<String, dynamic> json) =>
      RiskFactorSelfReflectDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : RiskFactorSelfReflectDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class RiskFactorSelfReflectDetailsData {
  String? userId;
  int? ratingType;
  List<SliderData>? sliderList;
  List<SliderData>? radioList;
  List<CheckboxList>? checkboxList;
  List<dynamic>? reflectCheckboxList;

  RiskFactorSelfReflectDetailsData({
    this.userId,
    this.ratingType,
    this.sliderList,
    this.radioList,
    this.checkboxList,
    this.reflectCheckboxList,
  });

  factory RiskFactorSelfReflectDetailsData.fromJson(
          Map<String, dynamic> json) =>
      RiskFactorSelfReflectDetailsData(
        userId: json["user_id"],
        ratingType: json["rating_type"],
        sliderList: json["slider_list"] == null
            ? []
            : List<SliderData>.from(
                json["slider_list"]!.map((x) => SliderData.fromJson(x))),
        radioList: json["radio_list"] == null
            ? []
            : List<SliderData>.from(
                json["radio_list"]!.map((x) => SliderData.fromJson(x))),
        checkboxList: json["checkbox_list"] == null
            ? []
            : List<CheckboxList>.from(
                json["checkbox_list"]!.map((x) => CheckboxList.fromJson(x))),
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
            : List<dynamic>.from(checkboxList!.map((x) => x.toJson())),
        "reflect_checkbox_list": reflectCheckboxList == null
            ? []
            : List<dynamic>.from(reflectCheckboxList!.map((x) => x)),
      };
}

class CheckboxList {
  String? title;
  List<SliderData>? value;

  CheckboxList({
    this.title,
    this.value,
  });

  factory CheckboxList.fromJson(Map<String, dynamic> json) => CheckboxList(
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
