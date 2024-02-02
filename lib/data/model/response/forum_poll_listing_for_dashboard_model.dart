// To parse this JSON data, do
//
//     final forumPollQuestionAnswerForDashBoardModel = forumPollQuestionAnswerForDashBoardModelFromJson(jsonString);

import 'dart:convert';

ForumPollQuestionAnswerForDashBoardModel
    forumPollQuestionAnswerForDashBoardModelFromJson(String str) =>
        ForumPollQuestionAnswerForDashBoardModel.fromJson(json.decode(str));

String forumPollQuestionAnswerForDashBoardModelToJson(
        ForumPollQuestionAnswerForDashBoardModel data) =>
    json.encode(data.toJson());

class ForumPollQuestionAnswerForDashBoardModel {
  int? status;
  List<ForumDataForDashboard>? data;
  String? message;

  ForumPollQuestionAnswerForDashBoardModel({
    this.status,
    this.data,
    this.message,
  });

  factory ForumPollQuestionAnswerForDashBoardModel.fromJson(
          Map<String, dynamic> json) =>
      ForumPollQuestionAnswerForDashBoardModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<ForumDataForDashboard>.from(
                json["data"]!.map((x) => ForumDataForDashboard.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class ForumDataForDashboard {
  int? id;
  String? question;

  ForumDataForDashboard({
    this.id,
    this.question,
  });

  factory ForumDataForDashboard.fromJson(Map<String, dynamic> json) =>
      ForumDataForDashboard(
        id: json["id"],
        question: json["question"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
      };
}
