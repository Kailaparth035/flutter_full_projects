// To parse this JSON data, do
//
//     final myCoachesListModel = myCoachesListModelFromJson(jsonString);

import 'dart:convert';

MyCoachesListModel myCoachesListModelFromJson(String str) =>
    MyCoachesListModel.fromJson(json.decode(str));

String myCoachesListModelToJson(MyCoachesListModel data) =>
    json.encode(data.toJson());

class MyCoachesListModel {
  int? status;
  List<MyCoachesData>? data;
  String? message;

  MyCoachesListModel({
    this.status,
    this.data,
    this.message,
  });

  factory MyCoachesListModel.fromJson(Map<String, dynamic> json) =>
      MyCoachesListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<MyCoachesData>.from(
                json["data"]!.map((x) => MyCoachesData.fromJson(x))),
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

class MyCoachesData {
  int? id;
  String? name;
  String? email;
  String? photo;
  String? avgFeedback;
  String? nameInitials;
  String? connect;
  String? schedule;
  String? agreement;

  MyCoachesData({
    this.id,
    this.name,
    this.email,
    this.photo,
    this.avgFeedback,
    this.nameInitials,
    this.connect,
    this.schedule,
    this.agreement,
  });

  factory MyCoachesData.fromJson(Map<String, dynamic> json) => MyCoachesData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        photo: json["photo"],
        avgFeedback: json["avg_feedback"].toString(),
        nameInitials: json["name_initials"],
        connect: json["connect"],
        schedule: json["schedule"],
        agreement: json["agreement"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "photo": photo,
        "avg_feedback": avgFeedback,
        "name_initials": nameInitials,
        "connect": connect,
        "schedule": schedule,
        "agreement": agreement,
      };
}
