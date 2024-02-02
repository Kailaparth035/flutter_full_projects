// To parse this JSON data, do
//
//     final courseDetailsModel = courseDetailsModelFromJson(jsonString);

import 'dart:convert';

CourseDetailsModel courseDetailsModelFromJson(String str) =>
    CourseDetailsModel.fromJson(json.decode(str));

String courseDetailsModelToJson(CourseDetailsModel data) =>
    json.encode(data.toJson());

class CourseDetailsModel {
  int? status;
  CourseDetailsData? data;
  String? message;

  CourseDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) =>
      CourseDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : CourseDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class CourseDetailsData {
  List<QuestionDetail>? questionDetail;
  int? id;
  String? course;
  String? description;
  String? videoLink;

  List<CourseAttachment>? attachments;
  List<VideoLink>? enterpriseVideoLink;
  int? enterpriseId;
  String? shortDesc;
  String? longDesc;
  int? saveExternal;

  CourseDetailsData({
    this.questionDetail,
    this.id,
    this.enterpriseVideoLink,
    this.course,
    this.description,
    this.videoLink,
    this.attachments,
    this.enterpriseId,
    this.shortDesc,
    this.longDesc,
    this.saveExternal,
  });

  factory CourseDetailsData.fromJson(Map<String, dynamic> json) =>
      CourseDetailsData(
        questionDetail: json["questionDetail"] == null
            ? []
            : List<QuestionDetail>.from(
                json["questionDetail"]!.map((x) => QuestionDetail.fromJson(x))),
        id: json["id"],
        course: json["course"],
        description: json["description"],
        enterpriseId: json["enterprise_id"],
        videoLink: json["video_link"],
        enterpriseVideoLink: json["enterprise_video_link"] == null
            ? []
            : List<VideoLink>.from(json["enterprise_video_link"]!
                .map((x) => VideoLink.fromJson(x))),
        shortDesc: json["short_desc"],
        longDesc: json["long_desc"],
        saveExternal: json["save_external"],
        attachments: json["attachments"] == null
            ? []
            : List<CourseAttachment>.from(
                json["attachments"]!.map((x) => CourseAttachment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "questionDetail": questionDetail == null
            ? []
            : List<dynamic>.from(questionDetail!.map((x) => x.toJson())),
        "id": id,
        "course": course,
        "description": description,
        "video_link": videoLink,
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
      };
}

class CourseAttachment {
  String? attachmentUrl;
  String? attachmentTitle;

  CourseAttachment({
    this.attachmentUrl,
    this.attachmentTitle,
  });

  factory CourseAttachment.fromJson(Map<String, dynamic> json) =>
      CourseAttachment(
        attachmentUrl: json["attachment_url"],
        attachmentTitle: json["attachment_title"],
      );

  Map<String, dynamic> toJson() => {
        "attachment_url": attachmentUrl,
        "attachment_title": attachmentTitle,
      };
}

class QuestionDetail {
  int? questionId;
  String? question;
  List<QuestionOption>? options;

  QuestionDetail({
    this.questionId,
    this.question,
    this.options,
  });

  factory QuestionDetail.fromJson(Map<String, dynamic> json) => QuestionDetail(
        questionId: json["question_id"],
        question: json["question"],
        options: json["options"] == null
            ? []
            : List<QuestionOption>.from(
                json["options"]!.map((x) => QuestionOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "question": question,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
      };
}

class QuestionOption {
  int? answerId;
  String? value;
  bool? isSelected = false;

  QuestionOption({
    this.answerId,
    this.value,
    this.isSelected,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) => QuestionOption(
        answerId: json["answer_id"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "answer_id": answerId,
        "value": value,
      };
}

class VideoLink {
  String? videoUrl;
  String? videoType;

  VideoLink({
    this.videoUrl,
    this.videoType,
  });

  factory VideoLink.fromJson(Map<String, dynamic> json) => VideoLink(
        videoUrl: json["video_url"],
        videoType: json["video_type"],
      );

  Map<String, dynamic> toJson() => {
        "video_url": videoUrl,
        "video_type": videoType,
      };
}
