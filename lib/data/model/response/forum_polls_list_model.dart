// To parse this JSON data, do
//
//     final forumPollListModel = forumPollListModelFromJson(jsonString);

import 'dart:convert';

ForumPollListModel forumPollListModelFromJson(String str) =>
    ForumPollListModel.fromJson(json.decode(str));

String forumPollListModelToJson(ForumPollListModel data) =>
    json.encode(data.toJson());

class ForumPollListModel {
  int? status;
  List<ForumPollsData>? data;
  String? message;

  ForumPollListModel({
    this.status,
    this.data,
    this.message,
  });

  factory ForumPollListModel.fromJson(Map<String, dynamic> json) =>
      ForumPollListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<ForumPollsData>.from(
                json["data"]!.map((x) => ForumPollsData.fromJson(x))),
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

class ForumPollsData {
  int? id;
  String? question;
  List<ForumPollOptionData>? options;
  String? correctAnswer;
  int? questionEnabledisable;
  String? hashtags;
  List<ForumPollOptionData>? hashtag;

  ForumPollsData({
    this.id,
    this.question,
    this.options,
    this.correctAnswer,
    this.questionEnabledisable,
    this.hashtags,
    this.hashtag,
  });

  factory ForumPollsData.fromJson(Map<String, dynamic> json) => ForumPollsData(
        id: json["id"],
        question: json["question"],
        options: json["options"] == null
            ? []
            : List<ForumPollOptionData>.from(
                json["options"]!.map((x) => ForumPollOptionData.fromJson(x))),
        correctAnswer: json["correct_answer"].toString(),
        questionEnabledisable: json["question_enabledisable"],
        hashtags: json["hashtags"],
        hashtag: json["hashtag"] == null
            ? []
            : List<ForumPollOptionData>.from(
                json["hashtag"]!.map((x) => ForumPollOptionData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "correct_answer": correctAnswer,
        "question_enabledisable": questionEnabledisable,
        "hashtags": hashtags,
        "hashtag": hashtag == null
            ? []
            : List<dynamic>.from(hashtag!.map((x) => x.toJson())),
      };
}

class ForumPollOptionData {
  int? id;
  String? name;

  ForumPollOptionData({
    this.id,
    this.name,
  });

  factory ForumPollOptionData.fromJson(Map<String, dynamic> json) =>
      ForumPollOptionData(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
