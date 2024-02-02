// To parse this JSON data, do
//
//     final newsDetailsModel = newsDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/comment_list_model.dart';

NewsDetailsModel newsDetailsModelFromJson(String str) =>
    NewsDetailsModel.fromJson(json.decode(str));

String newsDetailsModelToJson(NewsDetailsModel data) =>
    json.encode(data.toJson());

class NewsDetailsModel {
  int? status;
  NewsDetailsData? data;
  String? message;

  NewsDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory NewsDetailsModel.fromJson(Map<String, dynamic> json) =>
      NewsDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : NewsDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class NewsDetailsData {
  int? id;
  int? enterpriseId;
  String? photo;
  String? title;
  String? description;
  String? slug;
  String? createdDate;
  String? loginUserName;
  String? loginUserPhoto;
  String? loginUserSelfInitial;
  int? commentInputEnable;
  List<CommentData>? commentHtml;

  NewsDetailsData({
    this.id,
    this.enterpriseId,
    this.photo,
    this.title,
    this.description,
    this.slug,
    this.createdDate,
    this.loginUserName,
    this.loginUserPhoto,
    this.loginUserSelfInitial,
    this.commentInputEnable,
    this.commentHtml,
  });

  factory NewsDetailsData.fromJson(Map<String, dynamic> json) =>
      NewsDetailsData(
        id: json["id"],
        enterpriseId: json["enterprise_id"],
        photo: json["photo"],
        title: json["title"],
        description: json["description"],
        slug: json["slug"],
        createdDate: json["created_date"],
        loginUserName: json["login_user_name"],
        loginUserPhoto: json["login_user_photo"],
        loginUserSelfInitial: json["login_user_selfInitial"],
        commentInputEnable: json["comment_input_enable"],
        commentHtml: json["commentHtml"] == null
            ? []
            : List<CommentData>.from(
                json["commentHtml"]!.map((x) => CommentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "enterprise_id": enterpriseId,
        "photo": photo,
        "title": title,
        "description": description,
        "slug": slug,
        "created_date": createdDate,
        "login_user_name": loginUserName,
        "login_user_photo": loginUserPhoto,
        "login_user_selfInitial": loginUserSelfInitial,
        "comment_input_enable": commentInputEnable,
        "commentHtml": commentHtml == null
            ? []
            : List<dynamic>.from(commentHtml!.map((x) => x.toJson())),
      };
}

class CommentHtml {
  int? id;
  int? blogEnterpriseId;
  int? commentId;
  String? description;
  int? userId;
  int? isManager;
  String? userName;
  dynamic photo;
  String? selfInitial;
  String? commentTime;
  int? replyBox;
  int? haveChild;
  List<dynamic>? child;

  CommentHtml({
    this.id,
    this.blogEnterpriseId,
    this.commentId,
    this.description,
    this.userId,
    this.isManager,
    this.userName,
    this.photo,
    this.selfInitial,
    this.commentTime,
    this.replyBox,
    this.haveChild,
    this.child,
  });

  factory CommentHtml.fromJson(Map<String, dynamic> json) => CommentHtml(
        id: json["id"],
        blogEnterpriseId: json["blog_enterprise_id"],
        commentId: json["comment_id"],
        description: json["description"],
        userId: json["user_id"],
        isManager: json["is_manager"],
        userName: json["user_name"],
        photo: json["photo"],
        selfInitial: json["selfInitial"],
        commentTime: json["comment_time"],
        replyBox: json["reply_box"],
        haveChild: json["have_child"],
        child: json["child"] == null
            ? []
            : List<CommentHtml>.from(
                json["child"]!.map((x) => CommentHtml.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "blog_enterprise_id": blogEnterpriseId,
        "comment_id": commentId,
        "description": description,
        "user_id": userId,
        "is_manager": isManager,
        "user_name": userName,
        "photo": photo,
        "selfInitial": selfInitial,
        "comment_time": commentTime,
        "reply_box": replyBox,
        "have_child": haveChild,
        "child": child == null ? [] : List<dynamic>.from(child!.map((x) => x)),
      };
}
