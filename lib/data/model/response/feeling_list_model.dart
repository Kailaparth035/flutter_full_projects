// To parse this JSON data, do
//
//     final feelingListModel = feelingListModelFromJson(jsonString);

import 'dart:convert';

FeelingListModel feelingListModelFromJson(String str) =>
    FeelingListModel.fromJson(json.decode(str));

String feelingListModelToJson(FeelingListModel data) =>
    json.encode(data.toJson());

class FeelingListModel {
  int? status;
  FeelingListData? data;
  String? message;

  FeelingListModel({
    this.status,
    this.data,
    this.message,
  });

  factory FeelingListModel.fromJson(Map<String, dynamic> json) =>
      FeelingListModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : FeelingListData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class FeelingListData {
  List<FeelingListDataValue>? positive;
  List<FeelingListDataValue>? negative;
  String? noteMsg;

  FeelingListData({
    this.positive,
    this.negative,
    this.noteMsg,
  });

  factory FeelingListData.fromJson(Map<String, dynamic> json) =>
      FeelingListData(
          positive: json["Positive"] == null
              ? []
              : List<FeelingListDataValue>.from(json["Positive"]!
                  .map((x) => FeelingListDataValue.fromJson(x))),
          negative: json["Negative"] == null
              ? []
              : List<FeelingListDataValue>.from(json["Negative"]!
                  .map((x) => FeelingListDataValue.fromJson(x))),
          noteMsg: json["note_msg"] ?? "");

  Map<String, dynamic> toJson() => {
        "noteMsg": noteMsg,
        "Positive": positive == null
            ? []
            : List<dynamic>.from(positive!.map((x) => x.toJson())),
        "Negative": negative == null
            ? []
            : List<dynamic>.from(negative!.map((x) => x.toJson())),
      };
}

class FeelingListDataValue {
  int? id;
  String? name;
  bool? isChecked;

  FeelingListDataValue({this.id, this.name, this.isChecked});

  factory FeelingListDataValue.fromJson(Map<String, dynamic> json) =>
      FeelingListDataValue(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
