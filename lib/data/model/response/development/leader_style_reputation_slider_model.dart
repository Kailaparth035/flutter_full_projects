import 'dart:convert';

import 'package:aspirevue/data/model/response/development/slider_data_model.dart';

LeaderStyleReputaionSliderModel leaderStyleReputaionModelFromJson(String str) =>
    LeaderStyleReputaionSliderModel.fromJson(json.decode(str));

String leaderStyleReputaionModelToJson(LeaderStyleReputaionSliderModel data) =>
    json.encode(data.toJson());

class LeaderStyleReputaionSliderModel {
  int? status;
  LeaderStyleReputaionSliderData? data;
  String? message;

  LeaderStyleReputaionSliderModel({
    this.status,
    this.data,
    this.message,
  });

  factory LeaderStyleReputaionSliderModel.fromJson(Map<String, dynamic> json) =>
      LeaderStyleReputaionSliderModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : LeaderStyleReputaionSliderData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class LeaderStyleReputaionSliderData {
  String? styleId;
  String? userId;
  List<String>? inviteOption;
  String? text;
  String? count;

  ReputationFeedback? reputationFeedback;
  String? isShowPurchaseView;

  String? isEnableSlider;
  String? relationWithLoginUser;

  ReputationFeedbackSuperVisor? reputationFeedbackSupervisor;

  LeaderStyleReputaionSliderData({
    this.styleId,
    this.userId,
    this.inviteOption,
    this.text,
    this.count,
    this.reputationFeedback,
    this.isShowPurchaseView,
    this.isEnableSlider,
    this.relationWithLoginUser,
    this.reputationFeedbackSupervisor,
  });

  factory LeaderStyleReputaionSliderData.fromJson(Map<String, dynamic> json) =>
      LeaderStyleReputaionSliderData(
        styleId: json["style_id"],
        userId: json["user_id"],
        inviteOption: json["invite_option"] == null
            ? []
            : List<String>.from(json["invite_option"]!.map((x) => x)),
        text: json["text"],
        count: json["count"]?.toString(),
        reputationFeedback: json["reputation_feedback"] == null
            ? null
            : ReputationFeedback.fromJson(json["reputation_feedback"]),
        isShowPurchaseView: json["is_show_purchase_view"]?.toString(),
        isEnableSlider: json["is_enable_slider"]?.toString(),
        relationWithLoginUser: json["relation_with_loginUser"]?.toString(),
        reputationFeedbackSupervisor:
            json["reputation_feedback_supervisor"] == null
                ? null
                : ReputationFeedbackSuperVisor.fromJson(
                    json["reputation_feedback_supervisor"]),
      );

  Map<String, dynamic> toJson() => {
        "style_id": styleId,
        "user_id": userId,
        "invite_option": inviteOption == null
            ? []
            : List<dynamic>.from(inviteOption!.map((x) => x)),
        "text": text,
        "count": count,
        "reputation_feedback": reputationFeedback?.toJson(),
      };
}

class ReputationFeedbackSuperVisor {
  List<SliderData>? list;
  String? title1;

  ReputationFeedbackSuperVisor({
    this.list,
    this.title1,
  });

  factory ReputationFeedbackSuperVisor.fromJson(Map<String, dynamic> json) =>
      ReputationFeedbackSuperVisor(
        list: json["list"] == null
            ? []
            : List<SliderData>.from(
                json["list"]!.map((x) => SliderData.fromJson(x))),
        title1: json["title_1"],
      );

  Map<String, dynamic> toJson() => {
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
        "title_1": title1,
      };
}

class ReputationFeedback {
  List<ListElement>? list;
  String? title1;

  ReputationFeedback({
    this.list,
    this.title1,
  });

  factory ReputationFeedback.fromJson(Map<String, dynamic> json) =>
      ReputationFeedback(
        list: json["list"] == null
            ? []
            : List<ListElement>.from(
                json["list"]!.map((x) => ListElement.fromJson(x))),
        title1: json["title_1"],
      );

  Map<String, dynamic> toJson() => {
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
        "title_1": title1,
      };
}

class ListElement {
  String? areaId;
  String? areaName;
  String? increaseType;
  String? decreaseType;
  String? action;

  ListElement({
    this.areaId,
    this.areaName,
    this.increaseType,
    this.decreaseType,
    this.action,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        areaId: json["AreaId"]?.toString(),
        areaName: json["AreaName"],
        increaseType: json["increase_type"]?.toString(),
        decreaseType: json["decrease_type"]?.toString(),
        action: json["action"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "AreaId": areaId,
        "AreaName": areaName,
        "increase_type": increaseType,
        "decrease_type": decreaseType,
        "action": action,
      };
}
