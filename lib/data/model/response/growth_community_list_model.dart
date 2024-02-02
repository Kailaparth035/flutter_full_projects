// To parse this JSON data, do
//
//     final growthCommunityListModel = growthCommunityListModelFromJson(jsonString);

import 'dart:convert';

GrowthCommunityListModel growthCommunityListModelFromJson(String str) =>
    GrowthCommunityListModel.fromJson(json.decode(str));

String growthCommunityListModelToJson(GrowthCommunityListModel data) =>
    json.encode(data.toJson());

class GrowthCommunityListModel {
  int? status;
  GrowthCommunityData? data;
  String? message;

  GrowthCommunityListModel({
    this.status,
    this.data,
    this.message,
  });

  factory GrowthCommunityListModel.fromJson(Map<String, dynamic> json) =>
      GrowthCommunityListModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : GrowthCommunityData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class GrowthCommunityData {
  List<GrowthCommunityListData>? list;
  int? count;

  GrowthCommunityData({
    this.list,
    this.count,
  });

  factory GrowthCommunityData.fromJson(Map<String, dynamic> json) =>
      GrowthCommunityData(
        list: json["list"] == null
            ? []
            : List<GrowthCommunityListData>.from(
                json["list"]!.map((x) => GrowthCommunityListData.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
        "count": count,
      };
}

class GrowthCommunityListData {
  int? id;
  String? userId;
  String? firstName;
  String? lastName;
  String? nameInitials;
  String? photo;
  dynamic companyId;
  String? positionName;
  String? roleName;
  String? isRegistered;
  String? isFollow;
  String? isPromoteToColleague;

  //------------  prms for contacts ------------
  String? emailAddress;
  String? phone;
  int? isInvited;

  GrowthCommunityListData({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.nameInitials,
    this.photo,
    this.companyId,
    this.positionName,
    this.roleName,
    this.isRegistered,
    this.isFollow,
    this.isPromoteToColleague,
    this.emailAddress,
    this.phone,
    this.isInvited,
  });

  factory GrowthCommunityListData.fromJson(Map<String, dynamic> json) =>
      GrowthCommunityListData(
        id: json["id"],
        userId: json["user_id"]?.toString(),
        firstName: json["first_name"],
        lastName: json["last_name"],
        nameInitials: json["name_initials"],
        photo: json["photo"],
        companyId: json["company_id"],
        positionName: json["position_name"],
        roleName: json["role_name"],
        isRegistered: json["is_registered"],
        isFollow: json["is_follow"],
        isPromoteToColleague: json["is_promote_to_colleague"],
        emailAddress: json["email_address"],
        isInvited: json["is_invited"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "name_initials": nameInitials,
        "photo": photo,
        "company_id": companyId,
        "position_name": positionName,
        "role_name": roleName,
        "is_registered": isRegistered,
        "is_follow": isFollow,
        "is_promote_to_colleague": isPromoteToColleague,
      };
}
