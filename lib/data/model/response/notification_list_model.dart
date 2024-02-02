// To parse this JSON data, do
//
//     final notificationListModel = notificationListModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/action_item_model.dart';

NotificationListModel notificationListModelFromJson(String str) =>
    NotificationListModel.fromJson(json.decode(str));

String notificationListModelToJson(NotificationListModel data) =>
    json.encode(data.toJson());

class NotificationListModel {
  int? status;
  List<NotificationListData>? data;
  String? message;

  NotificationListModel({
    this.status,
    this.data,
    this.message,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) =>
      NotificationListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<NotificationListData>.from(
                json["data"]!.map((x) => NotificationListData.fromJson(x))),
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

class NotificationListData {
  int? id;
  String? title;
  String? description;
  String? link;
  String? nameInitials;
  String? name;
  String? photo;
  int? notType;
  String? time;

  String? styleId;
  String? userId;
  String? tabName;
  String? userType;
  OpenType? openType;
  int? isShowElarning;
  String? goalId;
  String? goalType;
  String? inviterId;

  int? isAcceptDeclineOption;

  NotificationListData({
    this.id,
    this.title,
    this.description,
    this.link,
    this.nameInitials,
    this.name,
    this.photo,
    this.notType,
    this.time,
    this.openType,
    this.styleId,
    this.userId,
    this.tabName,
    this.userType,
    this.isShowElarning,
    this.goalId,
    this.goalType,
    this.isAcceptDeclineOption,
    this.inviterId,
  });

  factory NotificationListData.fromJson(Map<String, dynamic> json) =>
      NotificationListData(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        link: json["link"],
        nameInitials: json["name_initials"],
        name: json["name"],
        photo: json["photo"],
        notType: json["not_type"],
        time: json["time"],
        openType: openTypeValues.map[json["open_type"]]!,
        styleId: json["style_id"]?.toString(),
        userId: json["user_id"]?.toString(),
        tabName: json["tab_name"],
        userType: json["user_type"],
        isShowElarning: json["is_elearning_show"] ?? 0,
        goalId: json["goal_id"],
        goalType: json["Goal_type"],
        isAcceptDeclineOption: json["is_accept_decline_option"] ?? 0,
        inviterId: json["inviter_id"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "link": link,
        "name_initials": nameInitials,
        "name": name,
        "photo": photo,
        "not_type": notType,
        "time": time,
        "open_type": openTypeValues.reverse[openType],
        "style_id": styleId,
        "user_id": userId,
        "tab_name": tabName,
        "user_type": userType,
        "goal_id": goalId,
      };
}
