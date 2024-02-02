// To parse this JSON data, do
//
//     final insightFeedModel = insightFeedModelFromJson(jsonString);

import 'dart:convert';

InsightFeedModel insightFeedModelFromJson(String str) =>
    InsightFeedModel.fromJson(json.decode(str));

String insightFeedModelToJson(InsightFeedModel data) =>
    json.encode(data.toJson());

class InsightFeedModel {
  int? status;
  Data? data;
  String? message;

  InsightFeedModel({
    this.status,
    this.data,
    this.message,
  });

  factory InsightFeedModel.fromJson(Map<String, dynamic> json) =>
      InsightFeedModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  List<Record>? record;
  int? userFollwedHastag;
  int? displayFollowUnfollowBtn;
  int? followUnfollowBtnDisable;
  String? hashtagId;

  Data({
    this.record,
    this.userFollwedHastag,
    this.displayFollowUnfollowBtn,
    this.followUnfollowBtnDisable,
    this.hashtagId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userFollwedHastag: json["user_follow_hashtag"] ?? 0,
        displayFollowUnfollowBtn: json["display_follow_unfollow_btn"] ?? 0,
        followUnfollowBtnDisable: json["follow_unfollow_btn_disable"] ?? 0,
        hashtagId:
            json["hashtag_id"] == null ? "" : json["hashtag_id"].toString(),
        record: json["record"] == null
            ? []
            : List<Record>.from(json["record"]!.map((x) => Record.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "record": record == null
            ? []
            : List<dynamic>.from(record!.map((x) => x.toJson())),
      };
}

class Record {
  int? id;
  int? postPrivacy;
  String? description;
  String? sharePostId;
  List<Record>? sharePostHtml;
  String? usertagsIds;
  int? userId;
  int? postType;
  String? userName;
  String? companyName;
  String? positionName;
  String? firstName;
  int? loginUserId;
  String? loginUserName;
  String? photo;
  String? loginPhoto;
  String? selfInitial;
  String? loginSelfInitial;
  String? postTime;
  String? postFileIds;
  List<PostFile>? postFiles;
  String? postLikeCount;
  String? postShareCount;
  String? postCommentCount;
  int? isPostLike;
  String? fellingActivityId;
  int? postInspired;
  String? postInspiredName;
  int? postContactInspired;
  String? postInviteeFirstname;
  String? postInviteeLastname;
  String? postInviteeEmail;
  int? postPivotal;
  String? postPivotalName;
  int? postContactPivotal;
  String? postPivotalFirstname;
  String? postPivotalLastname;
  String? postPivotalEmail;
  int? isCount;
  String? postActivity;
  List<dynamic>? commentHtml;
  String? postStarRatingAvg;
  String? postStarRatingCount;
  String? postStarRating;
  int? isPostSaved;
  int? isUserFollowed;
  int? isUserBlocked;
  int? isUseAsGlobal;
  List<TagLine>? tagLine;
  String? shareUrl;
  Record(
      {this.id,
      this.postPrivacy,
      this.description,
      this.sharePostId,
      this.sharePostHtml,
      this.usertagsIds,
      this.userId,
      this.postType,
      this.userName,
      this.companyName,
      this.positionName,
      this.firstName,
      this.loginUserId,
      this.loginUserName,
      this.photo,
      this.loginPhoto,
      this.selfInitial,
      this.loginSelfInitial,
      this.postTime,
      this.postFileIds,
      this.postFiles,
      this.postLikeCount,
      this.postShareCount,
      this.postCommentCount,
      this.isPostLike,
      this.fellingActivityId,
      this.postInspired,
      this.postInspiredName,
      this.postContactInspired,
      this.postInviteeFirstname,
      this.postInviteeLastname,
      this.postInviteeEmail,
      this.postPivotal,
      this.postPivotalName,
      this.postContactPivotal,
      this.postPivotalFirstname,
      this.postPivotalLastname,
      this.postPivotalEmail,
      this.isCount,
      this.postActivity,
      this.commentHtml,
      this.postStarRatingAvg,
      this.postStarRatingCount,
      this.postStarRating,
      this.isPostSaved,
      this.isUserFollowed,
      this.isUserBlocked,
      this.isUseAsGlobal,
      this.shareUrl,
      this.tagLine});

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        postPrivacy: json["post_privacy"],
        description: json["description"],
        // sharePostId: json["share_post_id"]?.toString(),
        sharePostHtml: json["share_post_html"] == null
            ? []
            : json["share_post_html"] == ""
                ? null
                : List<Record>.from(
                    json["share_post_html"]!.map((x) => Record.fromJson(x))),
        usertagsIds: json["usertags_ids"],
        userId: json["user_id"],
        postType: json["post_type"],
        userName: json["user_name"],
        companyName: json["company_name"],
        positionName: json["position_name"],
        firstName: json["first_name"],
        loginUserId: json["login_user_id"],
        loginUserName: json["login_user_name"],
        photo: json["photo"],
        loginPhoto: json["login_photo"],
        selfInitial: json["selfInitial"],
        loginSelfInitial: json["login_selfInitial"],
        postTime: json["post_time"],
        shareUrl: json["share_url"]?.toString() ?? "",
        postFileIds: json["post_file_ids"],
        postFiles: json["post_files"] == null
            ? []
            : List<PostFile>.from(
                json["post_files"]!.map((x) => PostFile.fromJson(x))),
        tagLine: json["post_files"] == null
            ? []
            : List<TagLine>.from(
                json["tag_line"]!.map((x) => TagLine.fromJson(x))),
        postLikeCount: json["post_like_count"].toString(),
        postShareCount: json["post_share_count"].toString(),
        postCommentCount: json["post_comment_count"].toString(),
        isPostLike: json["is_post_like"],
        fellingActivityId: json["felling_activity_id"],
        postInspired: json["post_inspired"],
        postInspiredName: json["post_inspired_name"],
        postContactInspired: json["post_contact_inspired"],
        postInviteeFirstname: json["post_invitee_firstname"],
        postInviteeLastname: json["post_invitee_lastname"],
        postInviteeEmail: json["post_invitee_email"],
        postPivotal: json["post_pivotal"],
        postPivotalName: json["post_pivotal_name"],
        postContactPivotal: json["post_contact_pivotal"],
        postPivotalFirstname: json["post_pivotal_firstname"],
        postPivotalLastname: json["post_pivotal_lastname"],
        postPivotalEmail: json["post_pivotal_email"],
        isCount: json["is_count"],
        postActivity: json["post_activity"],
        commentHtml: json["commentHtml"] == null
            ? []
            : List<dynamic>.from(json["commentHtml"]!.map((x) => x)),

        postStarRatingAvg: json["post_star_rating_avg"]?.toString(),
        postStarRatingCount: json["post_star_rating_count"].toString(),
        postStarRating: json["post_star_rating"].toString(),
        isPostSaved: json["is_post_saved"],
        isUserFollowed: json["is_user_followed"],
        isUserBlocked: json["is_user_blocked"],
        isUseAsGlobal: json["is_use_as_global"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_privacy": postPrivacy,
        "description": description,
        "share_post_id": sharePostId,
        "share_post_html": sharePostHtml,
        "usertags_ids": usertagsIds,
        "user_id": userId,
        "post_type": postType,
        "user_name": userName,
        "company_name": companyName,
        "position_name": positionName,
        "first_name": firstName,
        "login_user_id": loginUserId,
        "login_user_name": loginUserName,
        "photo": photo,
        "login_photo": loginPhoto,
        "selfInitial": selfInitial,
        "login_selfInitial": loginSelfInitial,
        "post_time": postTime,
        "post_file_ids": postFileIds,
        "post_files": postFiles == null
            ? []
            : List<dynamic>.from(postFiles!.map((x) => x.toJson())),
        "post_like_count": postLikeCount,
        "post_share_count": postShareCount,
        "post_comment_count": postCommentCount,
        "is_post_like": isPostLike,
        "felling_activity_id": fellingActivityId,
        "post_inspired": postInspired,
        "post_inspired_name": postInspiredName,
        "post_contact_inspired": postContactInspired,
        "post_invitee_firstname": postInviteeFirstname,
        "post_invitee_lastname": postInviteeLastname,
        "post_invitee_email": postInviteeEmail,
        "post_pivotal": postPivotal,
        "post_pivotal_name": postPivotalName,
        "post_contact_pivotal": postContactPivotal,
        "post_pivotal_firstname": postPivotalFirstname,
        "post_pivotal_lastname": postPivotalLastname,
        "post_pivotal_email": postPivotalEmail,
        "is_count": isCount,
        "post_activity": postActivity,
        "commentHtml": commentHtml == null
            ? []
            : List<dynamic>.from(commentHtml!.map((x) => x)),
        "post_star_rating_avg": postStarRatingAvg,
        "post_star_rating_count": postStarRatingCount,
        "post_star_rating": postStarRating,
        "is_post_saved": isPostSaved,
        "is_user_followed": isUserFollowed,
        "is_user_blocked": isUserBlocked,
        "is_use_as_global": isUseAsGlobal,
      };
}

class PostFile {
  String? id;
  int? postId;
  String? name;
  String? postType;
  int? isDelete;
  String? fullPath;

  PostFile({
    this.id,
    this.postId,
    this.name,
    this.postType,
    this.isDelete,
    this.fullPath,
  });

  factory PostFile.fromJson(Map<String, dynamic> json) => PostFile(
        id: json["id"]?.toString(),
        postId: json["post_id"],
        name: json["name"],
        postType: json["post_type"]?.toString(),
        isDelete: json["is_delete"],
        fullPath: json["full_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "name": name,
        "post_type": postType,
        "is_delete": isDelete,
        "full_path": fullPath,
      };
}

class TagLine {
  String? id;
  String? name;
  String? companyName;
  String? position;
  String? type;
  String? userType;
  String? photo;
  TagLine({
    this.id,
    this.name,
    this.companyName,
    this.position,
    this.type,
    this.userType,
    this.photo,
  });

  factory TagLine.fromJson(Map<String, dynamic> json) => TagLine(
        id: json["id"].toString(),
        name: json["name"],
        companyName: json["company_name"],
        position: json["position"],
        type: json["type"],
        userType: json["user_type"],
        photo: json["photo"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "company_name": companyName,
        "position": position,
        "type": type,
        "user_type": userType,
        "photo": photo,
      };
}
