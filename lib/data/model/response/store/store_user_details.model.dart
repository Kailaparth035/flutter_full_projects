// To parse this JSON data, do
//
//     final storeUserDetailsModel = storeUserDetailsModelFromJson(jsonString);

import 'dart:convert';

StoreUserDetailsModel storeUserDetailsModelFromJson(String str) =>
    StoreUserDetailsModel.fromJson(json.decode(str));

String storeUserDetailsModelToJson(StoreUserDetailsModel data) =>
    json.encode(data.toJson());

class StoreUserDetailsModel {
  int? status;
  StoreUserDetailData? data;
  String? message;

  StoreUserDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory StoreUserDetailsModel.fromJson(Map<String, dynamic> json) =>
      StoreUserDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : StoreUserDetailData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class StoreUserDetailData {
  List<SessionList>? sessionList;
  String? coachName;
  String? coachId;
  String? photo;
  String? bio;
  String? email;
  String? country;
  String? state;
  String? specialties;
  String? hourlyRate;
  String? sessionValue;
  String? isDisable;
  String? isVerify;
  String? promoVerify;
  String? isVerifyClass;
  String? verifyText;
  String? product;
  String? productId;

  String? type;
  String? promocode;
  String? price;
  String? deletePrice;

  StoreUserDetailData(
      {this.sessionList,
      this.coachName,
      this.coachId,
      this.photo,
      this.bio,
      this.email,
      this.country,
      this.state,
      this.specialties,
      this.hourlyRate,
      this.sessionValue,
      this.isDisable,
      this.isVerify,
      this.promoVerify,
      this.isVerifyClass,
      this.verifyText,
      this.product,
      this.productId,
      this.type,
      this.promocode,
      this.price,
      this.deletePrice});

  factory StoreUserDetailData.fromJson(Map<String, dynamic> json) =>
      StoreUserDetailData(
        sessionList: json["session_list"] == null
            ? []
            : List<SessionList>.from(
                json["session_list"]!.map((x) => SessionList.fromJson(x))),
        coachName: json["coach_name"]?.toString(),
        price: json["price"]?.toString(),
        coachId: json["coach_id"]?.toString(),
        photo: json["photo"]?.toString(),
        bio: json["bio"]?.toString(),
        email: json["email"]?.toString(),
        country: json["country"]?.toString(),
        state: json["state"]?.toString(),
        specialties: json["specialties"]?.toString(),
        hourlyRate: json["hourly_rate"]?.toString(),
        sessionValue: json["session_value"]?.toString(),
        isDisable: json["is_disable"]?.toString(),
        isVerify: json["is_verify"]?.toString(),
        promoVerify: json["promo_verify"]?.toString(),
        isVerifyClass: json["is_verify_class"]?.toString(),
        verifyText: json["verify_text"]?.toString(),
        product: json["product"]?.toString(),
        productId: json["product_id"]?.toString(),
        type: json["type"]?.toString(),
        promocode: json["promocode"]?.toString(),
        deletePrice: json["delete_price"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "session_list": sessionList == null
            ? []
            : List<dynamic>.from(sessionList!.map((x) => x.toJson())),
        "coach_name": coachName,
        "coach_id": coachId,
        "photo": photo,
        "bio": bio,
        "email": email,
        "country": country,
        "state": state,
        "specialties": specialties,
        "hourly_rate": hourlyRate,
        "session_value": sessionValue,
        "is_disable": isDisable,
        "is_verify": isVerify,
        "promo_verify": promoVerify,
        "is_verify_class": isVerifyClass,
        "verify_text": verifyText,
        "product": product,
        "type": type,
        "promocode": promocode,
      };
}

class SessionList {
  String? title;
  String? price;
  String? discountPrice;

  SessionList({
    this.title,
    this.price,
    this.discountPrice,
  });

  factory SessionList.fromJson(Map<String, dynamic> json) => SessionList(
        title: json["title"],
        price: json["price"]?.toString(),
        discountPrice: json["discount_price"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "discount_price": discountPrice,
      };
}
