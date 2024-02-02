// To parse this JSON data, do
//
//     final commentListModel = commentListModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

CommentListModel commentListModelFromJson(String str) =>
    CommentListModel.fromJson(json.decode(str));

String commentListModelToJson(CommentListModel data) =>
    json.encode(data.toJson());

class CommentListModel {
  int? status;
  CommentDataMain? data;
  String? message;

  CommentListModel({
    this.status,
    this.data,
    this.message,
  });

  factory CommentListModel.fromJson(Map<String, dynamic> json) =>
      CommentListModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : CommentDataMain.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class CommentDataMain {
  int? commentCount;
  List<CommentData>? record;

  CommentDataMain({
    this.commentCount,
    this.record,
  });

  factory CommentDataMain.fromJson(Map<String, dynamic> json) =>
      CommentDataMain(
        commentCount: json["comment_count"] ?? 0,
        record: json["record"] == null
            ? []
            : List<CommentData>.from(
                json["record"]!.map((x) => CommentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "comment_count": commentCount,
        "record": record == null
            ? []
            : List<dynamic>.from(record!.map((x) => x.toJson())),
      };
}

class CommentData {
  int? id;
  int? postId;
  int? commentId;
  String? description;
  int? userId;
  String? userType;
  String? userName;
  String? positions;
  String? company;
  String? hoverData;
  String? photo;
  String? selfInitial;
  String? commentTime;
  String? commentFileIds;
  List<CommentFile>? commentFiles;
  int? replyBox;
  int? haveChild;
  List<CommentData>? child;

  CommentData({
    this.id,
    this.postId,
    this.commentId,
    this.description,
    this.userId,
    this.userType,
    this.userName,
    this.positions,
    this.company,
    this.hoverData,
    this.photo,
    this.selfInitial,
    this.commentTime,
    this.commentFileIds,
    this.commentFiles,
    this.replyBox,
    this.haveChild,
    this.child,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        id: json["id"],
        postId: json["post_id"],
        commentId: json["comment_id"],
        description: json["description"],
        userId: json["user_id"],
        userType: json["user_type"],
        userName: json["user_name"],
        positions: json["positions"],
        company: json["company"],
        hoverData: json["hover_data"],
        photo: json["photo"],
        selfInitial: json["selfInitial"],
        commentTime: json["comment_time"],
        commentFileIds: json["comment_file_ids"],
        commentFiles: json["comment_files"] == null
            ? []
            : List<CommentFile>.from(
                json["comment_files"]!.map((x) => CommentFile.fromJson(x))),
        replyBox: json["reply_box"],
        haveChild: json["have_child"],
        child: json["child"] == null
            ? []
            : List<CommentData>.from(
                json["child"]!.map((x) => CommentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "comment_id": commentId,
        "description": description,
        "user_id": userId,
        "user_type": userType,
        "user_name": userName,
        "positions": positions,
        "company": company,
        "hover_data": hoverData,
        "photo": photo,
        "selfInitial": selfInitial,
        "comment_time": commentTime,
        "comment_file_ids": commentFileIds,
        "comment_files": commentFiles == null
            ? []
            : List<dynamic>.from(commentFiles!.map((x) => x.toJson())),
        "reply_box": replyBox,
        "have_child": haveChild,
        "child": child == null
            ? []
            : List<dynamic>.from(child!.map((x) => x.toJson())),
      };
}

class CommentFile {
  int? id;
  int? postId;
  int? commentId;
  String? postType;
  String? name;
  int? isDelete;
  File? thumbnail;

  CommentFile({
    this.id,
    this.postId,
    this.commentId,
    this.postType,
    this.name,
    this.isDelete,
    this.thumbnail,
  });

  factory CommentFile.fromJson(Map<String, dynamic> json) => CommentFile(
        id: json["id"],
        postId: json["post_id"],
        commentId: json["comment_id"],
        postType: json["post_type"],
        name: json["name"],
        isDelete: json["is_delete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "comment_id": commentId,
        "post_type": postType,
        "name": name,
        "is_delete": isDelete,
      };
}
