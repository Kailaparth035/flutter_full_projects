// To parse this JSON data, do
//
//     final forumPollDetailModel = forumPollDetailModelFromJson(jsonString);

import 'dart:convert';

ForumPollDetailModel forumPollDetailModelFromJson(String str) =>
    ForumPollDetailModel.fromJson(json.decode(str));

String forumPollDetailModelToJson(ForumPollDetailModel data) =>
    json.encode(data.toJson());

class ForumPollDetailModel {
  int? status;
  ForumPollDetailData? data;
  String? message;

  ForumPollDetailModel({
    this.status,
    this.data,
    this.message,
  });

  factory ForumPollDetailModel.fromJson(Map<String, dynamic> json) =>
      ForumPollDetailModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : ForumPollDetailData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
        "message": message,
      };
}

class ForumPollDetailData {
  int? id;
  String? question;
  List<Hashtag>? options;
  String? correctAnswer;
  int? questionEnabledisable;
  List<Hashtag>? hashtag;
  String? attachment;

  ForumPollDetailData({
    this.id,
    this.question,
    this.options,
    this.correctAnswer,
    this.questionEnabledisable,
    this.hashtag,
    this.attachment,
  });

  factory ForumPollDetailData.fromJson(Map<String, dynamic> json) =>
      ForumPollDetailData(
        id: json["id"],
        question: json["question"],
        options: json["options"] == null
            ? []
            : List<Hashtag>.from(
                json["options"]!.map((x) => Hashtag.fromJson(x))),
        correctAnswer: json["correct_answer"].toString(),
        questionEnabledisable: json["question_enabledisable"],
        hashtag: json["hashtag"] == null
            ? []
            : List<Hashtag>.from(
                json["hashtag"]!.map((x) => Hashtag.fromJson(x))),
        attachment: json["attachment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "correct_answer": correctAnswer,
        "question_enabledisable": questionEnabledisable,
        "hashtag": hashtag == null
            ? []
            : List<dynamic>.from(hashtag!.map((x) => x.toJson())),
        "attachment": attachment,
      };
}

class Hashtag {
  int? id;
  String? name;

  Hashtag({
    this.id,
    this.name,
  });

  factory Hashtag.fromJson(Map<String, dynamic> json) => Hashtag(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
