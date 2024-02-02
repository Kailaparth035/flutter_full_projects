// To parse this JSON data, do
//
//     final postDetailModel = postDetailModelFromJson(jsonString);

import 'dart:convert';

PostDetailModel postDetailModelFromJson(String str) =>
    PostDetailModel.fromJson(json.decode(str));

String postDetailModelToJson(PostDetailModel data) =>
    json.encode(data.toJson());

class PostDetailModel {
  int? status;
  PostDetailData? data;
  String? message;

  PostDetailModel({
    this.status,
    this.data,
    this.message,
  });

  factory PostDetailModel.fromJson(Map<String, dynamic> json) =>
      PostDetailModel(
        status: json["status"],
        data:
            json["data"] == null ? null : PostDetailData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class PostDetailData {
  int? postId;
  int? userId;
  int? questionOne;
  String? postTags;
  List<FellingActivity>? taggedUser;
  List<FilesMedia>? filesMedia;
  String? postInspired;
  String? postInspiredName;
  String? postPivotal;
  String? postPivotalName;
  int? postType;
  String? fellingActivityId;
  List<FellingActivity>? fellingActivity;
  String? postText;

  PostDetailData({
    this.postId,
    this.userId,
    this.questionOne,
    this.postTags,
    this.taggedUser,
    this.filesMedia,
    this.postInspired,
    this.postInspiredName,
    this.postPivotal,
    this.postPivotalName,
    this.postType,
    this.fellingActivityId,
    this.fellingActivity,
    this.postText,
  });

  factory PostDetailData.fromJson(Map<String, dynamic> json) => PostDetailData(
        postId: json["post_id"],
        userId: json["user_id"],
        questionOne: json["question_one"],
        postTags: json["post_tags"],
        taggedUser: json["tagged_user"] == null
            ? []
            : List<FellingActivity>.from(
                json["tagged_user"]!.map((x) => FellingActivity.fromJson(x))),
        filesMedia: json["files_media"] == null
            ? []
            : List<FilesMedia>.from(
                json["files_media"]!.map((x) => FilesMedia.fromJson(x))),
        postInspired: json["post_inspired"].toString(),
        postInspiredName: json["post_inspired_name"],
        postPivotal: json["post_pivotal"].toString(),
        postPivotalName: json["post_pivotal_name"],
        postType: json["post_type"],
        fellingActivityId: json["felling_activity_id"].toString(),
        fellingActivity: json["felling_activity"] == null
            ? []
            : List<FellingActivity>.from(json["felling_activity"]!
                .map((x) => FellingActivity.fromJson(x))),
        postText: json["post_text"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "user_id": userId,
        "question_one": questionOne,
        "post_tags": postTags,
        "tagged_user": taggedUser == null
            ? []
            : List<dynamic>.from(taggedUser!.map((x) => x.toJson())),
        "files_media": filesMedia == null
            ? []
            : List<dynamic>.from(filesMedia!.map((x) => x.toJson())),
        "post_inspired": postInspired,
        "post_inspired_name": postInspiredName,
        "post_pivotal": postPivotal,
        "post_pivotal_name": postPivotalName,
        "post_type": postType,
        "felling_activity_id": fellingActivityId,
        "felling_activity": fellingActivity == null
            ? []
            : List<dynamic>.from(fellingActivity!.map((x) => x.toJson())),
      };
}

class FellingActivity {
  int? id;
  String? name;
  String? type;

  FellingActivity({
    this.id,
    this.name,
    this.type,
  });

  factory FellingActivity.fromJson(Map<String, dynamic> json) =>
      FellingActivity(
        id: json["id"],
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class FilesMedia {
  int? id;
  String? type;
  String? path;
  bool isDeleted;

  FilesMedia({
    this.id,
    this.type,
    this.path,
    this.isDeleted = false,
  });

  factory FilesMedia.fromJson(Map<String, dynamic> json) => FilesMedia(
        id: json["id"],
        type: json["type"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "path": path,
      };
}
