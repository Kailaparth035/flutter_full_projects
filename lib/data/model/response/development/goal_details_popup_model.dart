// To parse this JSON data, do
//
//     final goalDetailsPopupModel = goalDetailsPopupModelFromJson(jsonString);

import 'dart:convert';

GoalDetailsPopupModel goalDetailsPopupModelFromJson(String str) =>
    GoalDetailsPopupModel.fromJson(json.decode(str));

String goalDetailsPopupModelToJson(GoalDetailsPopupModel data) =>
    json.encode(data.toJson());

class GoalDetailsPopupModel {
  int? status;
  GoalDetailsPopupData? data;
  String? message;

  GoalDetailsPopupModel({
    this.status,
    this.data,
    this.message,
  });

  factory GoalDetailsPopupModel.fromJson(Map<String, dynamic> json) =>
      GoalDetailsPopupModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : GoalDetailsPopupData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class GoalDetailsPopupData {
  int? goalId;
  int? areaId;
  String? actionPlan;
  String? targetDate;
  String? isChecked;
  String? goalType;
  String? objSituationalCue;

  GoalDetailsPopupData({
    this.goalId,
    this.areaId,
    this.actionPlan,
    this.targetDate,
    this.isChecked,
    this.goalType,
    this.objSituationalCue,
  });

  factory GoalDetailsPopupData.fromJson(Map<String, dynamic> json) =>
      GoalDetailsPopupData(
        goalId: json["goal_id"],
        areaId: json["area_id"],
        actionPlan: json["action_plan"],
        targetDate: json["target_date"],
        isChecked: json["is_checked"],
        goalType: json["Goal_type"],
        objSituationalCue: json["obj_situational_cue"],
      );

  Map<String, dynamic> toJson() => {
        "goal_id": goalId,
        "area_id": areaId,
        "action_plan": actionPlan,
        "target_date": targetDate,
        "is_checked": isChecked,
        "Goal_type": goalType,
        "obj_situational_cue": objSituationalCue,
      };
}
