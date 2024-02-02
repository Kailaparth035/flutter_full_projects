// To parse this JSON data, do
//
//     final globalSearchModel = globalSearchModelFromJson(jsonString);

import 'dart:convert';

GlobalSearchModel globalSearchModelFromJson(String str) =>
    GlobalSearchModel.fromJson(json.decode(str));

String globalSearchModelToJson(GlobalSearchModel data) =>
    json.encode(data.toJson());

class GlobalSearchModel {
  int? status;
  List<SearchData>? data;
  String? message;

  GlobalSearchModel({
    this.status,
    this.data,
    this.message,
  });

  factory GlobalSearchModel.fromJson(Map<String, dynamic> json) =>
      GlobalSearchModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<SearchData>.from(
                json["data"]!.map((x) => SearchData.fromJson(x))),
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

class SearchData {
  int? id;
  String? name;
  String? photo;
  SearchType? type;

  SearchData({
    this.id,
    this.name,
    this.photo,
    this.type,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
        type: typeValues.map[json["type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "type": typeValues.reverse[type],
      };
}

enum SearchType { user, hashtag }

final typeValues =
    EnumValues({"hashtag": SearchType.hashtag, "user": SearchType.user});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
