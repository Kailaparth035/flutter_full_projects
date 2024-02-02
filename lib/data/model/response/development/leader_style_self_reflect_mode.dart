// To parse this JSON data, do
//
//     final leaderStyleSelfReflectDetailsModel = leaderStyleSelfReflectDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/slider_data_model.dart'; 

LeaderStyleSelfReflectDetailsModel leaderStyleSelfReflectDetailsModelFromJson(
        String str) =>
    LeaderStyleSelfReflectDetailsModel.fromJson(json.decode(str));

String leaderStyleSelfReflectDetailsModelToJson(
        LeaderStyleSelfReflectDetailsModel data) =>
    json.encode(data.toJson());

class LeaderStyleSelfReflectDetailsModel {
  int? status;
  LeaderStyleSelfReflectDetailsData? data;
  String? message;

  LeaderStyleSelfReflectDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory LeaderStyleSelfReflectDetailsModel.fromJson(
          Map<String, dynamic> json) =>
      LeaderStyleSelfReflectDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : LeaderStyleSelfReflectDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class LeaderStyleSelfReflectDetailsData {
  String? userId;
  int? ratingType;
  List<dynamic>? sliderList;
  List<SliderData>? radioList;
  List<dynamic>? checkboxList;
  List<dynamic>? reflectCheckboxList;

  LeaderStyleSelfReflectDetailsData({
    this.userId,
    this.ratingType,
    this.sliderList,
    this.radioList,
    this.checkboxList,
    this.reflectCheckboxList,
  });

  factory LeaderStyleSelfReflectDetailsData.fromJson(
          Map<String, dynamic> json) =>
      LeaderStyleSelfReflectDetailsData(
        userId: json["user_id"],
        ratingType: json["rating_type"],
        sliderList: json["slider_list"] == null
            ? []
            : List<dynamic>.from(json["slider_list"]!.map((x) => x)),
        radioList: json["radio_list"] == null
            ? []
            : List<SliderData>.from(
                json["radio_list"]!.map((x) => SliderData.fromJson(x))),
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
            : List<dynamic>.from(sliderList!.map((x) => x)),
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
