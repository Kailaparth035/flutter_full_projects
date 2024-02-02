// To parse this JSON data, do
//
//     final workSkillReputaionSliderModel = workSkillReputaionModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/slider_data_model.dart';

WorkSkillReputaionSliderModel workSkillReputaionModelFromJson(String str) =>
    WorkSkillReputaionSliderModel.fromJson(json.decode(str));

String workSkillReputaionModelToJson(WorkSkillReputaionSliderModel data) =>
    json.encode(data.toJson());

class WorkSkillReputaionSliderModel {
  int? status;
  WorkSkillReputaionSliderData? data;
  String? message;

  WorkSkillReputaionSliderModel({
    this.status,
    this.data,
    this.message,
  });

  factory WorkSkillReputaionSliderModel.fromJson(Map<String, dynamic> json) =>
      WorkSkillReputaionSliderModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : WorkSkillReputaionSliderData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class WorkSkillReputaionSliderData {
  String? styleId;
  String? userId;
  String? text;
  int? count;
  String? type1;
  String? type2;
  String? type3;
  String? type4;
  String? type5;
  List<ReputationFeedback>? reputationFeedback;
  String? isShowPurchaseView;

  String? isEnableSlider;
  String? relationWithLoginUser;

  List<ReputationFeedbackSupervisor>? reputationFeedbackSupervisor;
  List<Comment>? comment;

  String? type2Supervisor;
  String? type3Supervisor;
  String? type4Supervisor;

  String? surveyUrl;
  String? valueCount;

  WorkSkillReputaionSliderData({
    this.styleId,
    this.userId,
    this.text,
    this.count,
    this.type1,
    this.type2,
    this.type3,
    this.type4,
    this.type5,
    this.reputationFeedback,
    this.isShowPurchaseView,
    this.isEnableSlider,
    this.relationWithLoginUser,
    this.reputationFeedbackSupervisor,
    this.comment,
    this.type2Supervisor,
    this.type3Supervisor,
    this.type4Supervisor,
    this.surveyUrl,
    this.valueCount,
  });

  factory WorkSkillReputaionSliderData.fromJson(Map<String, dynamic> json) =>
      WorkSkillReputaionSliderData(
        styleId: json["style_id"],
        userId: json["user_id"],
        text: json["text"],
        count: json["count"],
        type1: json["type_1"],
        type2: json["type_2"],
        type3: json["type_3"],
        type4: json["type_4"],
        type5: json["type_5"],
        reputationFeedback: json["reputation_feedback"] == null
            ? []
            : List<ReputationFeedback>.from(json["reputation_feedback"]!
                .map((x) => ReputationFeedback.fromJson(x))),
        isShowPurchaseView: json["is_show_purchase_view"]?.toString(),
        isEnableSlider: json["is_enable_slider"]?.toString(),
        relationWithLoginUser: json["relation_with_loginUser"]?.toString(),
        reputationFeedbackSupervisor:
            json["reputation_feedback_supervisor"] == null
                ? []
                : List<ReputationFeedbackSupervisor>.from(
                    json["reputation_feedback_supervisor"]!
                        .map((x) => ReputationFeedbackSupervisor.fromJson(x))),
        comment: json["comment"] == null
            ? []
            : List<Comment>.from(
                json["comment"]!.map((x) => Comment.fromJson(x))),
        type2Supervisor: json["type_2_supervisor"],
        type3Supervisor: json["type_3_supervisor"],
        type4Supervisor: json["type_4_supervisor"],
        surveyUrl: json["survey_url"],
        valueCount: json["value_count"],
      );

  Map<String, dynamic> toJson() => {
        "style_id": styleId,
        "user_id": userId,
        "text": text,
        "count": count,
        "type_1": type1,
        "type_2": type2,
        "type_3": type3,
        "type_4": type4,
        "type_5": type5,
        "survey_url": surveyUrl,
        "reputation_feedback": reputationFeedback == null
            ? []
            : List<dynamic>.from(reputationFeedback!.map((x) => x.toJson())),
      };
}

class ReputationFeedback {
  String? title;
  List<SliderData>? value;

  ReputationFeedback({
    this.title,
    this.value,
  });

  factory ReputationFeedback.fromJson(Map<String, dynamic> json) =>
      ReputationFeedback(
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

class ReputationFeedbackSupervisor {
  String? title;
  List<SliderData>? value;

  ReputationFeedbackSupervisor({
    this.title,
    this.value,
  });

  factory ReputationFeedbackSupervisor.fromJson(Map<String, dynamic> json) =>
      ReputationFeedbackSupervisor(
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

class Comment {
  String? title;
  List<CommentDetails>? value;

  Comment({
    this.title,
    this.value,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        title: json["title"],
        value: json["value"] == null
            ? []
            : List<CommentDetails>.from(
                json["value"]!.map((x) => CommentDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value == null
            ? []
            : List<dynamic>.from(value!.map((x) => x.toJson())),
      };
}

class CommentDetails {
  String? surveyComment;
  int? id;

  CommentDetails({
    this.surveyComment,
    this.id,
  });

  factory CommentDetails.fromJson(Map<String, dynamic> json) => CommentDetails(
        surveyComment: json["survey_comment"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "survey_comment": surveyComment,
        "id": id,
      };
}
