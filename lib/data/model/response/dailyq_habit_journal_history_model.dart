// To parse this JSON data, do
//
//     final dailyqHabitJournalHistoryModel = dailyqHabitJournalHistoryModelFromJson(jsonString);

import 'dart:convert';

DailyqHabitJournalHistoryModel dailyqHabitJournalHistoryModelFromJson(
        String str) =>
    DailyqHabitJournalHistoryModel.fromJson(json.decode(str));

String dailyqHabitJournalHistoryModelToJson(
        DailyqHabitJournalHistoryModel data) =>
    json.encode(data.toJson());

class DailyqHabitJournalHistoryModel {
  int? status;
  List<DailyqHabitJournalHistoryData>? data;
  String? message;

  DailyqHabitJournalHistoryModel({
    this.status,
    this.data,
    this.message,
  });

  factory DailyqHabitJournalHistoryModel.fromJson(Map<String, dynamic> json) =>
      DailyqHabitJournalHistoryModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<DailyqHabitJournalHistoryData>.from(json["data"]!
                .map((x) => DailyqHabitJournalHistoryData.fromJson(x))),
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

class DailyqHabitJournalHistoryData {
  int? id;
  String? name;
  int? reminderCount;

  DailyqHabitJournalHistoryData({
    this.id,
    this.name,
    this.reminderCount,
  });

  factory DailyqHabitJournalHistoryData.fromJson(Map<String, dynamic> json) =>
      DailyqHabitJournalHistoryData(
        id: json["id"],
        name: json["name"],
        reminderCount: json["reminder_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reminder_count": reminderCount,
      };
}
