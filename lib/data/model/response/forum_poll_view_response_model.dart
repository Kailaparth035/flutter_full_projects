// To parse this JSON data, do
//
//     final forumPollViewResponseModel = forumPollViewResponseModelFromJson(jsonString);

import 'dart:convert';

ForumPollViewResponseModel forumPollViewResponseModelFromJson(String str) =>
    ForumPollViewResponseModel.fromJson(json.decode(str));

String forumPollViewResponseModelToJson(ForumPollViewResponseModel data) =>
    json.encode(data.toJson());

class ForumPollViewResponseModel {
  int? status;
  ForumPollViewResponseData? data;
  String? message;

  ForumPollViewResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory ForumPollViewResponseModel.fromJson(Map<String, dynamic> json) =>
      ForumPollViewResponseModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : ForumPollViewResponseData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class ForumPollViewResponseData {
  String? questionName;
  List<LabelDetail>? labelDetail;
  String? correctAnswer;
  int? count;

  ForumPollViewResponseData({
    this.questionName,
    this.labelDetail,
    this.correctAnswer,
    this.count,
  });

  factory ForumPollViewResponseData.fromJson(Map<String, dynamic> json) =>
      ForumPollViewResponseData(
        questionName: json["question_name"],
        labelDetail: json["label_detail"] == null
            ? []
            : List<LabelDetail>.from(
                json["label_detail"]!.map((x) => LabelDetail.fromJson(x))),
        correctAnswer: json["correct_answer"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "question_name": questionName,
        "label_detail": labelDetail == null
            ? []
            : List<dynamic>.from(labelDetail!.map((x) => x.toJson())),
        "correct_answer": correctAnswer,
        "count": count,
      };
}

class LabelDetail {
  int? percentage;
  String? title;
  int? count;

  LabelDetail({
    this.percentage,
    this.title,
    this.count,
  });

  factory LabelDetail.fromJson(Map<String, dynamic> json) => LabelDetail(
        percentage: json["percentage"],
        title: json["title"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "percentage": percentage,
        "title": title,
        "count": count,
      };
}
