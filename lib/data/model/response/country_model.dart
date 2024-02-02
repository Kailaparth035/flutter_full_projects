// To parse this JSON data, do
//
//     final countryModel = countryModelFromJson(jsonString);

import 'dart:convert';

CountryModel countryModelFromJson(String str) =>
    CountryModel.fromJson(json.decode(str));

String countryModelToJson(CountryModel data) => json.encode(data.toJson());

class CountryModel {
  int? status;
  List<CountryData>? data;
  String? message;

  CountryModel({
    this.status,
    this.data,
    this.message,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<CountryData>.from(
                json["data"]!.map((x) => CountryData.fromJson(x))),
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

class CountryData {
  int? id;
  String? countryName;
  String? sortname;

  CountryData({
    this.id,
    this.countryName,
    this.sortname,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        id: json["id"],
        countryName: json["country_name"],
        sortname: json["sortname"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_name": countryName,
        "sortname": sortname,
      };
}
