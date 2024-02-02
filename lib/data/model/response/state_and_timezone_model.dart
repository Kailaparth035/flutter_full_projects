// To parse this JSON data, do
//
//     final stateAndTimeZoneModel = stateAndTimeZoneModelFromJson(jsonString);

import 'dart:convert';

StateAndTimeZoneModel stateAndTimeZoneModelFromJson(String str) =>
    StateAndTimeZoneModel.fromJson(json.decode(str));

String stateAndTimeZoneModelToJson(StateAndTimeZoneModel data) =>
    json.encode(data.toJson());

class StateAndTimeZoneModel {
  int? status;
  StateAndTimeZoneData? data;
  String? message;

  StateAndTimeZoneModel({
    this.status,
    this.data,
    this.message,
  });

  factory StateAndTimeZoneModel.fromJson(Map<String, dynamic> json) =>
      StateAndTimeZoneModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : StateAndTimeZoneData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class StateAndTimeZoneData {
  List<StateData>? states;
  List<TimeZoneData>? timeZone;

  StateAndTimeZoneData({
    this.states,
    this.timeZone,
  });

  factory StateAndTimeZoneData.fromJson(Map<String, dynamic> json) =>
      StateAndTimeZoneData(
        states: json["States"] == null
            ? []
            : List<StateData>.from(
                json["States"]!.map((x) => StateData.fromJson(x))),
        timeZone: json["TimeZone"] == null
            ? []
            : List<TimeZoneData>.from(
                json["TimeZone"]!.map((x) => TimeZoneData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "States": states == null
            ? []
            : List<dynamic>.from(states!.map((x) => x.toJson())),
        "TimeZone": timeZone == null
            ? []
            : List<dynamic>.from(timeZone!.map((x) => x.toJson())),
      };
}

class StateData {
  int? id;
  String? stateName;

  StateData({
    this.id,
    this.stateName,
  });

  factory StateData.fromJson(Map<String, dynamic> json) => StateData(
        id: json["id"],
        stateName: json["state_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state_name": stateName,
      };
}

class TimeZoneData {
  int? zoneId;
  String? zoneName;

  TimeZoneData({
    this.zoneId,
    this.zoneName,
  });

  factory TimeZoneData.fromJson(Map<String, dynamic> json) => TimeZoneData(
        zoneId: json["zone_id"],
        zoneName: json["zone_name"],
      );

  Map<String, dynamic> toJson() => {
        "zone_id": zoneId,
        "zone_name": zoneName,
      };
}
