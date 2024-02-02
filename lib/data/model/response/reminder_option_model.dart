// To parse this JSON data, do
//
//     final reminderOptionModel = reminderOptionModelFromJson(jsonString);

import 'dart:convert';

ReminderOptionModel reminderOptionModelFromJson(String str) =>
    ReminderOptionModel.fromJson(json.decode(str));

String reminderOptionModelToJson(ReminderOptionModel data) =>
    json.encode(data.toJson());

class ReminderOptionModel {
  int? status;
  ReminderOptionData? data;
  String? message;

  ReminderOptionModel({
    this.status,
    this.data,
    this.message,
  });

  factory ReminderOptionModel.fromJson(Map<String, dynamic> json) =>
      ReminderOptionModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : ReminderOptionData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class ReminderOptionData {
  String? goalId;
  String? userId;
  String? id;
  int? isAllDays;
  int? sun;
  int? mon;
  int? tue;
  int? wed;
  int? thu;
  int? fri;
  int? sat;
  String? time;
  String? min;
  String? timeType;
  String? email;
  String? timeZone;

  String? country;

  ReminderOptionData({
    this.goalId,
    this.userId,
    this.id,
    this.isAllDays,
    this.sun,
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.fri,
    this.sat,
    this.time,
    this.min,
    this.timeType,
    this.email,
    this.timeZone,
    this.country,
  });

  factory ReminderOptionData.fromJson(Map<String, dynamic> json) =>
      ReminderOptionData(
        goalId: json["goal_id"],
        userId: json["user_id"].toString(),
        id: json["id"].toString(),
        isAllDays: json["is_all_days"],
        sun: json["Sun"],
        mon: json["Mon"],
        tue: json["Tue"],
        wed: json["Wed"],
        thu: json["Thu"],
        fri: json["Fri"],
        sat: json["Sat"],
        time: json["time"],
        min: json["min"],
        timeType: json["time_type"],
        email: json["email"],
        timeZone: json["time_zone"],
        country: json["country"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": goalId.toString(),
        "user_id": userId.toString(),
        "is_all_days": isAllDays.toString(),
        "Sun": sun.toString(),
        "Mon": mon.toString(),
        "Tue": tue.toString(),
        "Wed": wed.toString(),
        "Thu": thu.toString(),
        "Fri": fri.toString(),
        "Sat": sat.toString(),
        "time": time.toString(),
        "min": min.toString(),
        "time_type": timeType.toString(),
        "email": email.toString(),
        "time_zone": timeZone.toString(),
        "country": country.toString(),
      };

  Map<String, dynamic> toJsonForEmotions() => {
        "id": id.toString(),
        "user_id": userId.toString(),
        "is_all_days": isAllDays.toString(),
        "Sun": sun.toString(),
        "Mon": mon.toString(),
        "Tue": tue.toString(),
        "Wed": wed.toString(),
        "Thu": thu.toString(),
        "Fri": fri.toString(),
        "Sat": sat.toString(),
        "time": time.toString(),
        "min": min.toString(),
        "time_type": timeType.toString(),
        "email": email.toString(),
        "time_zone": timeZone.toString(),
        "country": country.toString(),
      };
}
