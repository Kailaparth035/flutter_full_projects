// To parse this JSON data, do
//
//     final myConnectionSettingModel = myConnectionSettingModelFromJson(jsonString);

import 'dart:convert';

MyConnectionSettingModel myConnectionSettingModelFromJson(String str) =>
    MyConnectionSettingModel.fromJson(json.decode(str));

String myConnectionSettingModelToJson(MyConnectionSettingModel data) =>
    json.encode(data.toJson());

class MyConnectionSettingModel {
  int? status;
  MyConnectionSettingData? data;
  String? message;

  MyConnectionSettingModel({
    this.status,
    this.data,
    this.message,
  });

  factory MyConnectionSettingModel.fromJson(Map<String, dynamic> json) =>
      MyConnectionSettingModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : MyConnectionSettingData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class MyConnectionSettingData {
  List<GiveDirectreport>? giveFeedback;
  List<GiveDirectreport>? receiveFeedback;
  List<GiveDirectreport>? receiveFeedbackValue;
  List<GiveDirectreport>? giveFeedbackValue;
  String? id;
  String? userId;
  String? showGrowth;
  String? startPage;
  String? communityFavorite;
  List<GiveDirectreport>? receiveSupervisors;
  List<GiveDirectreport>? giveSupervisors;
  List<GiveDirectreport>? receivePeers;
  List<GiveDirectreport>? receiveDirectreport;
  List<GiveDirectreport>? giveDirectreport;
  List<GiveDirectreport>? givePeers;

  MyConnectionSettingData({
    this.giveFeedback,
    this.receiveFeedback,
    this.receiveFeedbackValue,
    this.giveFeedbackValue,
    this.id,
    this.userId,
    this.showGrowth,
    this.startPage,
    this.communityFavorite,
    this.receiveSupervisors,
    this.giveSupervisors,
    this.receivePeers,
    this.receiveDirectreport,
    this.giveDirectreport,
    this.givePeers,
  });

  factory MyConnectionSettingData.fromJson(Map<String, dynamic> json) =>
      MyConnectionSettingData(
        giveFeedback: json["give_feedback"] == null
            ? []
            : List<GiveDirectreport>.from(json["give_feedback"]!
                .map((x) => GiveDirectreport.fromJson(x))),
        receiveFeedback: json["receive_feedback"] == null
            ? []
            : List<GiveDirectreport>.from(json["receive_feedback"]!
                .map((x) => GiveDirectreport.fromJson(x))),
        receiveFeedbackValue: json["receive_feedback_value"] == null
            ? []
            : List<GiveDirectreport>.from(json["receive_feedback_value"]!
                .map((x) => GiveDirectreport.fromJson(x))),
        giveFeedbackValue: json["give_feedback_value"] == null
            ? []
            : List<GiveDirectreport>.from(json["give_feedback_value"]!
                .map((x) => GiveDirectreport.fromJson(x))),
        id: json["id"].toString(),
        userId: json["user_id"].toString(),
        showGrowth: json["show_growth"].toString(),
        startPage: json["start_page"].toString(),
        communityFavorite: json["community_favorite"].toString(),
        receiveSupervisors: json["receive_supervisors"] == null
            ? []
            : List<GiveDirectreport>.from(json["receive_supervisors"]!
                .map((x) => GiveDirectreport.fromJson(x))),
        giveSupervisors: json["give_supervisors"] == null
            ? []
            : List<GiveDirectreport>.from(json["give_supervisors"]!
                .map((x) => GiveDirectreport.fromJson(x))),
        receivePeers: json["receive_peers"] == null
            ? []
            : List<GiveDirectreport>.from(json["receive_peers"]!
                .map((x) => GiveDirectreport.fromJson(x))),
        receiveDirectreport: json["receive_directreport"] == null
            ? []
            : List<GiveDirectreport>.from(json["receive_directreport"]!
                .map((x) => GiveDirectreport.fromJson(x))),
        giveDirectreport: json["give_directreport"] == null
            ? []
            : List<GiveDirectreport>.from(json["give_directreport"]!
                .map((x) => GiveDirectreport.fromJson(x))),
        givePeers: json["give_peers"] == null
            ? []
            : List<GiveDirectreport>.from(
                json["give_peers"]!.map((x) => GiveDirectreport.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "give_feedback": giveFeedback == null
            ? []
            : List<dynamic>.from(giveFeedback!.map((x) => x.toJson())),
        "receive_feedback": receiveFeedback == null
            ? []
            : List<dynamic>.from(receiveFeedback!.map((x) => x.toJson())),
        "receive_feedback_value": receiveFeedbackValue == null
            ? []
            : List<dynamic>.from(receiveFeedbackValue!.map((x) => x.toJson())),
        "give_feedback_value": giveFeedbackValue == null
            ? []
            : List<dynamic>.from(giveFeedbackValue!.map((x) => x.toJson())),
        "id": id,
        "user_id": userId,
        "show_growth": showGrowth,
        "start_page": startPage,
        "community_favorite": communityFavorite,
        "receive_supervisors": receiveSupervisors == null
            ? []
            : List<dynamic>.from(receiveSupervisors!.map((x) => x.toJson())),
        "give_supervisors": giveSupervisors == null
            ? []
            : List<dynamic>.from(giveSupervisors!.map((x) => x.toJson())),
        "receive_peers": receivePeers == null
            ? []
            : List<dynamic>.from(receivePeers!.map((x) => x.toJson())),
        "receive_directreport": receiveDirectreport == null
            ? []
            : List<dynamic>.from(receiveDirectreport!.map((x) => x.toJson())),
        "give_directreport": giveDirectreport == null
            ? []
            : List<dynamic>.from(giveDirectreport!.map((x) => x.toJson())),
        "give_peers": givePeers == null
            ? []
            : List<dynamic>.from(givePeers!.map((x) => x.toJson())),
      };
}

class GiveDirectreport {
  String? id;
  String? name;

  GiveDirectreport({
    this.id,
    this.name,
  });

  factory GiveDirectreport.fromJson(Map<String, dynamic> json) =>
      GiveDirectreport(
        id: json["id"].toString(),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
