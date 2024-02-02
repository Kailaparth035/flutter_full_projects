// To parse this JSON data, do
//
//     final manageFollowerModel = manageFollowerModelFromJson(jsonString);

import 'dart:convert';

ManageFollowerModel manageFollowerModelFromJson(String str) =>
    ManageFollowerModel.fromJson(json.decode(str));

String manageFollowerModelToJson(ManageFollowerModel data) =>
    json.encode(data.toJson());

class ManageFollowerModel {
  int? status;
  ManageFollowerData? data;
  String? message;

  ManageFollowerModel({
    this.status,
    this.data,
    this.message,
  });

  factory ManageFollowerModel.fromJson(Map<String, dynamic> json) =>
      ManageFollowerModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : ManageFollowerData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class ManageFollowerData {
  List<TernalFollower>? internalFollowers;
  List<TernalFollower>? externalFollowers;
  List<FollowerList>? followerList;
  int? roleId;
  int? gatherFeedbackScore;
  int? gatherFeedbackScoreDisplay;
  int? repeatEvery;
  String? repeatDuration;
  List<WeekDay>? weekDay;
  List<MonthType>? monthType;
  String? endType;
  String? endTypeValue;

  ManageFollowerData({
    this.internalFollowers,
    this.externalFollowers,
    this.followerList,
    this.roleId,
    this.gatherFeedbackScore,
    this.gatherFeedbackScoreDisplay,
    this.repeatEvery,
    this.repeatDuration,
    this.weekDay,
    this.monthType,
    this.endType,
    this.endTypeValue,
  });

  factory ManageFollowerData.fromJson(Map<String, dynamic> json) =>
      ManageFollowerData(
        internalFollowers: json["internal_followers"] == null
            ? []
            : List<TernalFollower>.from(json["internal_followers"]!
                .map((x) => TernalFollower.fromJson(x))),
        externalFollowers: json["external_followers"] == null
            ? []
            : List<TernalFollower>.from(json["external_followers"]!
                .map((x) => TernalFollower.fromJson(x))),
        followerList: json["follower_list"] == null
            ? []
            : List<FollowerList>.from(
                json["follower_list"]!.map((x) => FollowerList.fromJson(x))),
        roleId: json["role_id"],
        gatherFeedbackScore: json["gather_feedback_score"],
        gatherFeedbackScoreDisplay: json["gather_feedback_score_display"],
        repeatEvery: json["repeat_every"],
        repeatDuration: json["repeat_duration"],
        weekDay: json["week_day"] == null
            ? []
            : List<WeekDay>.from(
                json["week_day"]!.map((x) => WeekDay.fromJson(x))),
        monthType: json["month_type"] == null
            ? []
            : List<MonthType>.from(
                json["month_type"]!.map((x) => MonthType.fromJson(x))),
        endType: json["end_type"],
        endTypeValue: json["end_type_value"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "internal_followers": internalFollowers == null
            ? []
            : List<dynamic>.from(internalFollowers!.map((x) => x.toJson())),
        "external_followers": externalFollowers == null
            ? []
            : List<dynamic>.from(externalFollowers!.map((x) => x.toJson())),
        "follower_list": followerList == null
            ? []
            : List<dynamic>.from(followerList!.map((x) => x.toJson())),
        "role_id": roleId,
        "gather_feedback_score": gatherFeedbackScore,
        "gather_feedback_score_display": gatherFeedbackScoreDisplay,
        "repeat_every": repeatEvery,
        "repeat_duration": repeatDuration,
        "week_day": weekDay == null
            ? []
            : List<dynamic>.from(weekDay!.map((x) => x.toJson())),
        "month_type": monthType == null
            ? []
            : List<dynamic>.from(monthType!.map((x) => x.toJson())),
        "end_type": endType,
        "end_type_value": endTypeValue,
      };
}

class TernalFollower {
  int? id;
  String? name;

  TernalFollower({
    this.id,
    this.name,
  });

  factory TernalFollower.fromJson(Map<String, dynamic> json) => TernalFollower(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class FollowerList {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  bool? isCheck;

  FollowerList({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.isCheck,
  });

  factory FollowerList.fromJson(Map<String, dynamic> json) => FollowerList(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        isCheck: json["is_check"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "is_check": isCheck,
      };
}

class MonthType {
  String? title;
  int? value;
  int? checked;

  MonthType({
    this.title,
    this.value,
    this.checked,
  });

  factory MonthType.fromJson(Map<String, dynamic> json) => MonthType(
        title: json["title"],
        value: json["value"],
        checked: json["checked"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "checked": checked,
      };
}

class WeekDay {
  String? title;
  String? value;
  int? checked;

  WeekDay({
    this.title,
    this.value,
    this.checked,
  });

  factory WeekDay.fromJson(Map<String, dynamic> json) => WeekDay(
        title: json["title"],
        value: json["value"],
        checked: json["checked"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "checked": checked,
      };
}
