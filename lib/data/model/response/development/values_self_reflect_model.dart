// To parse this JSON data, do
//
//     final valuesSelfReflectDetailsModel = valuesSelfReflectDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/slider_data_model.dart';

ValuesSelfReflectDetailsModel valuesSelfReflectDetailsModelFromJson(
        String str) =>
    ValuesSelfReflectDetailsModel.fromJson(json.decode(str));

String valuesSelfReflectDetailsModelToJson(
        ValuesSelfReflectDetailsModel data) =>
    json.encode(data.toJson());

class ValuesSelfReflectDetailsModel {
  int? status;
  ValuesSelfReflectDetailsData? data;
  String? message;

  ValuesSelfReflectDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory ValuesSelfReflectDetailsModel.fromJson(Map<String, dynamic> json) =>
      ValuesSelfReflectDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : ValuesSelfReflectDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class ValuesSelfReflectDetailsData {
  String? userId;
  int? ratingType;
  String? title;
  List<SliderData>? sliderList;
  List<RadioList>? radioList;
  List<dynamic>? checkboxList;
  List<dynamic>? reflectCheckboxList;

  ValuesSelfReflectDetailsData({
    this.userId,
    this.ratingType,
    this.title,
    this.sliderList,
    this.radioList,
    this.checkboxList,
    this.reflectCheckboxList,
  });

  factory ValuesSelfReflectDetailsData.fromJson(Map<String, dynamic> json) =>
      ValuesSelfReflectDetailsData(
        userId: json["user_id"],
        ratingType: json["rating_type"],
        title: json["title"],
        sliderList: json["slider_list"] == null
            ? []
            : List<SliderData>.from(
                json["slider_list"]!.map((x) => SliderData.fromJson(x))),
        radioList: json["radio_list"] == null
            ? []
            : List<RadioList>.from(
                json["radio_list"]!.map((x) => RadioList.fromJson(x))),
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
        "title": title,
        "slider_list": sliderList == null
            ? []
            : List<SliderData>.from(sliderList!.map((x) => x.toJson())),
        "radio_list": radioList == null
            ? []
            : List<dynamic>.from(radioList!.map((x) => x.toJson())),
        "checkbox_list": checkboxList == null
            ? []
            : List<dynamic>.from(checkboxList!.map((x) => x)),
        "reflect_checkbox_list": reflectCheckboxList == null
            ? []
            : List<dynamic>.from(reflectCheckboxList!.map((x) => x)),
      };
}

class RadioList {
  List<SliderData>? radioList1;
  List<SliderData>? radioList2;

  RadioList({
    this.radioList1,
    this.radioList2,
  });

  factory RadioList.fromJson(Map<String, dynamic> json) => RadioList(
        radioList1: json["radio_list1"] == null
            ? []
            : List<SliderData>.from(
                json["radio_list1"]!.map((x) => SliderData.fromJson(x))),
        radioList2: json["radio_list2"] == null
            ? []
            : List<SliderData>.from(
                json["radio_list2"]!.map((x) => SliderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "radio_list1": radioList1 == null
            ? []
            : List<dynamic>.from(radioList1!.map((x) => x.toJson())),
        "radio_list2": radioList2 == null
            ? []
            : List<dynamic>.from(radioList2!.map((x) => x.toJson())),
      };
}
