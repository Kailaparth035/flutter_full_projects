// To parse this JSON data, do
//
//     final emotionsSelfReflectDetailsModel = emotionsSelfReflectDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/slider_data_model.dart';

EmotionsSelfReflectDetailsModel emotionsSelfReflectDetailsModelFromJson(
        String str) =>
    EmotionsSelfReflectDetailsModel.fromJson(json.decode(str));

String emotionsSelfReflectDetailsModelToJson(
        EmotionsSelfReflectDetailsModel data) =>
    json.encode(data.toJson());

class EmotionsSelfReflectDetailsModel {
  int? status;
  EmotionsSelfReflectDetailsData? data;
  String? message;

  EmotionsSelfReflectDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory EmotionsSelfReflectDetailsModel.fromJson(Map<String, dynamic> json) =>
      EmotionsSelfReflectDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : EmotionsSelfReflectDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class EmotionsSelfReflectDetailsData {
  String? userId;
  int? ratingType;
  List<SliderList>? sliderList;
  List<dynamic>? radioList;
  List<CheckboxList>? checkboxList;
  List<dynamic>? reflectCheckboxList;

  EmotionsSelfReflectDetailsData({
    this.userId,
    this.ratingType,
    this.sliderList,
    this.radioList,
    this.checkboxList,
    this.reflectCheckboxList,
  });

  factory EmotionsSelfReflectDetailsData.fromJson(Map<String, dynamic> json) =>
      EmotionsSelfReflectDetailsData(
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
  List<SliderData>? positiveEmotions;
  List<SliderData>? negativeEmotions;

  CheckboxList({
    this.positiveEmotions,
    this.negativeEmotions,
  });

  factory CheckboxList.fromJson(Map<String, dynamic> json) => CheckboxList(
        positiveEmotions: json["positive_emotions"] == null
            ? []
            : List<SliderData>.from(
                json["positive_emotions"]!.map((x) => SliderData.fromJson(x))),
        negativeEmotions: json["negative_emotions"] == null
            ? []
            : List<SliderData>.from(
                json["negative_emotions"]!.map((x) => SliderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "positive_emotions": positiveEmotions == null
            ? []
            : List<dynamic>.from(positiveEmotions!.map((x) => x.toJson())),
        "negative_emotions": negativeEmotions == null
            ? []
            : List<dynamic>.from(negativeEmotions!.map((x) => x.toJson())),
      };
}

class SliderList {
  String? title;
  List<SliderData>? value;
  String? average;
  String? colour;

  SliderList({
    this.title,
    this.value,
    this.average,
    this.colour,
  });

  factory SliderList.fromJson(Map<String, dynamic> json) => SliderList(
        title: json["title"],
        value: json["value"] == null
            ? []
            : List<SliderData>.from(
                json["value"]!.map((x) => SliderData.fromJson(x))),
        average: json["average"],
        colour: json["colour"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value == null
            ? []
            : List<dynamic>.from(value!.map((x) => x.toJson())),
        "average": average,
        "colour": colour,
      };
}
