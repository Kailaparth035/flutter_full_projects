import 'dart:convert';

import 'package:aspirevue/data/model/response/development/slider_data_model.dart';

ReputationSliderModel reputaionModelFromJson(String str) =>
    ReputationSliderModel.fromJson(json.decode(str));

String reputaionModelToJson(ReputationSliderModel data) =>
    json.encode(data.toJson());

class ReputationSliderModel {
  int? status;
  ReputationSliderData? data;
  String? message;

  ReputationSliderModel({
    this.status,
    this.data,
    this.message,
  });

  factory ReputationSliderModel.fromJson(Map<String, dynamic> json) =>
      ReputationSliderModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : ReputationSliderData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class ReputationSliderData {
  List<SliderData>? reputationFeedback;

  ListFirst? listFirst;
  ListSecond? listSecond;

  ListFirstSupervisor? listFirstSupervisor;
  ListSecondSupervisor? listSecondSupervisor;

  String? type1;
  String? type2;
  String? type3;
  String? type4;
  String? type5;
  String? isShowPurchaseView;
  String? isEnableSlider;
  String? relationWithLoginUser;

  ReputationSliderData(
      {this.reputationFeedback,
      this.listFirst,
      this.listSecond,
      this.type1,
      this.type2,
      this.type3,
      this.type4,
      this.type5,
      this.isShowPurchaseView,
      this.isEnableSlider,
      this.relationWithLoginUser,
      this.listFirstSupervisor,
      this.listSecondSupervisor});

  factory ReputationSliderData.fromJson(Map<String, dynamic> json) =>
      ReputationSliderData(
        reputationFeedback: json["reputation_feedback"] == null
            ? []
            : List<SliderData>.from(json["reputation_feedback"]!
                .map((x) => SliderData.fromJson(x))),
        listFirst: json["list_first"] == null
            ? null
            : ListFirst.fromJson(json["list_first"]),
        listSecond: json["list_second"] == null
            ? null
            : ListSecond.fromJson(json["list_second"]),
        type1: json["type_1"]?.toString(),
        type2: json["type_2"]?.toString(),
        type3: json["type_3"]?.toString(),
        type4: json["type_4"]?.toString(),
        type5: json["type_5"]?.toString(),
        isShowPurchaseView: json["is_show_purchase_view"]?.toString(),
        isEnableSlider: json["is_enable_slider"]?.toString(),
        relationWithLoginUser: json["relation_with_loginUser"]?.toString(),
        listFirstSupervisor: json["list_first_supervisor"] == null
            ? null
            : ListFirstSupervisor.fromJson(json["list_first_supervisor"]),
        listSecondSupervisor: json["list_second_supervisor"] == null
            ? null
            : ListSecondSupervisor.fromJson(json["list_second_supervisor"]),
      );

  Map<String, dynamic> toJson() => {
        "reputation_feedback": reputationFeedback == null
            ? []
            : List<dynamic>.from(reputationFeedback!.map((x) => x.toJson())),
      };
}

class ListFirst {
  List<ListFirstList>? list;
  String? title1;
  String? subtitle1;
  String? subtitle2;
  String? subtitle3;

  ListFirst({
    this.list,
    this.title1,
    this.subtitle1,
    this.subtitle2,
    this.subtitle3,
  });

  factory ListFirst.fromJson(Map<String, dynamic> json) => ListFirst(
        list: json["list_first"] == null
            ? []
            : List<ListFirstList>.from(
                json["list_first"]!.map((x) => ListFirstList.fromJson(x))),
        title1: json["title_1"],
        subtitle1: json["subtitle_1"],
        subtitle2: json["subtitle_2"],
        subtitle3: json["subtitle_3"],
      );

  Map<String, dynamic> toJson() => {
        "list_first": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
        "title_1": title1,
        "subtitle_1": subtitle1,
        "subtitle_2": subtitle2,
        "subtitle_3": subtitle3,
      };
}

class ListFirstList {
  int? areaId;
  String? areaName;
  String? leftMeaning;
  String? leastCount;
  String? mostCount;

  ListFirstList({
    this.areaId,
    this.areaName,
    this.leftMeaning,
    this.leastCount,
    this.mostCount,
  });

  factory ListFirstList.fromJson(Map<String, dynamic> json) => ListFirstList(
        areaId: json["AreaId"],
        areaName: json["AreaName"]?.toString(),
        leftMeaning: json["LeftMeaning"]?.toString(),
        leastCount: json["least_count"]?.toString(),
        mostCount: json["most_count"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "AreaId": areaId,
        "AreaName": areaName,
        "LeftMeaning": leftMeaning,
        "least_count": leastCount,
        "most_count": mostCount,
      };
}

class ListSecond {
  List<ListSecondList>? list;
  String? title1;
  String? subtitle1;
  String? subtitle2;
  String? subtitle3;
  String? subtitle4;

  ListSecond({
    this.list,
    this.title1,
    this.subtitle1,
    this.subtitle2,
    this.subtitle3,
    this.subtitle4,
  });

  factory ListSecond.fromJson(Map<String, dynamic> json) => ListSecond(
        list: json["list_second"] == null
            ? []
            : List<ListSecondList>.from(
                json["list_second"]!.map((x) => ListSecondList.fromJson(x))),
        title1: json["title_1"]?.toString(),
        subtitle1: json["subtitle_1"]?.toString(),
        subtitle2: json["subtitle_2"]?.toString(),
        subtitle3: json["subtitle_3"]?.toString(),
        subtitle4: json["subtitle_4"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "list_second": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
        "title_1": title1,
        "subtitle_1": subtitle1,
        "subtitle_2": subtitle2,
        "subtitle_3": subtitle3,
        "subtitle_4": subtitle4,
      };
}

class ListSecondList {
  int? areaId;
  String? areaName;
  String? notImportant;
  String? moderatelyCount;
  String? highlyCount;

  ListSecondList({
    this.areaId,
    this.areaName,
    this.notImportant,
    this.moderatelyCount,
    this.highlyCount,
  });

  factory ListSecondList.fromJson(Map<String, dynamic> json) => ListSecondList(
        areaId: json["AreaId"],
        areaName: json["AreaName"]?.toString(),
        notImportant: json["not_important"]?.toString(),
        moderatelyCount: json["moderately_count"]?.toString(),
        highlyCount: json["highly_count"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "AreaId": areaId,
        "AreaName": areaName,
        "not_important": notImportant,
        "moderately_count": moderatelyCount,
        "highly_count": highlyCount,
      };
}

// for supervisor

class ListFirstSupervisor {
  List<SliderData>? listFirst;
  String? title1;
  String? subtitle1;
  String? subtitle2;
  String? subtitle3;
  String? subtitle4;

  ListFirstSupervisor({
    this.listFirst,
    this.title1,
    this.subtitle1,
    this.subtitle2,
    this.subtitle3,
    this.subtitle4,
  });

  factory ListFirstSupervisor.fromJson(Map<String, dynamic> json) =>
      ListFirstSupervisor(
        listFirst: json["list_first"] == null
            ? []
            : List<SliderData>.from(
                json["list_first"]!.map((x) => SliderData.fromJson(x))),
        title1: json["title_1"],
        subtitle1: json["subtitle_1"],
        subtitle2: json["subtitle_2"],
        subtitle3: json["subtitle_3"],
        subtitle4: json["subtitle_4"],
      );

  Map<String, dynamic> toJson() => {
        "list_first": listFirst == null
            ? []
            : List<dynamic>.from(listFirst!.map((x) => x.toJson())),
        "title_1": title1,
        "subtitle_1": subtitle1,
        "subtitle_2": subtitle2,
        "subtitle_3": subtitle3,
        "subtitle_4": subtitle4,
      };
}

class ListSecondSupervisor {
  List<SliderData>? listFirst;
  String? title1;
  String? subtitle1;
  String? subtitle2;
  String? subtitle3;
  String? subtitle4;

  ListSecondSupervisor({
    this.listFirst,
    this.title1,
    this.subtitle1,
    this.subtitle2,
    this.subtitle3,
    this.subtitle4,
  });

  factory ListSecondSupervisor.fromJson(Map<String, dynamic> json) =>
      ListSecondSupervisor(
        listFirst: json["list_second"] == null
            ? []
            : List<SliderData>.from(
                json["list_second"]!.map((x) => SliderData.fromJson(x))),
        title1: json["title_1"],
        subtitle1: json["subtitle_1"],
        subtitle2: json["subtitle_2"],
        subtitle3: json["subtitle_3"],
        subtitle4: json["subtitle_4"],
      );

  Map<String, dynamic> toJson() => {
        "list_second": listFirst == null
            ? []
            : List<dynamic>.from(listFirst!.map((x) => x.toJson())),
        "title_1": title1,
        "subtitle_1": subtitle1,
        "subtitle_2": subtitle2,
        "subtitle_3": subtitle3,
        "subtitle_4": subtitle4,
      };
}
