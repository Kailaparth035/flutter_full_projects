// To parse this JSON data, do
//
//     final offerListModel = offerListModelFromJson(jsonString);

import 'dart:convert';

OfferListModel offerListModelFromJson(String str) =>
    OfferListModel.fromJson(json.decode(str));

String offerListModelToJson(OfferListModel data) => json.encode(data.toJson());

class OfferListModel {
  int? status;
  List<OfferData>? data;
  String? message;

  OfferListModel({
    this.status,
    this.data,
    this.message,
  });

  factory OfferListModel.fromJson(Map<String, dynamic> json) => OfferListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<OfferData>.from(
                json["data"]!.map((x) => OfferData.fromJson(x))),
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

class OfferData {
  String? id;
  String? title;
  String? description;
  String? discountAmount;
  String? masterproductId;
  String? price;
  String? offerPrice;
  String? offerLabel;
  String? isShowOfferAppliedButton;
  String? isShowAddToCartButton;
  String? isCoach;
  String? isShowAddToCartLabel;
  int? cartId;

  OfferData(
      {this.id,
      this.title,
      this.description,
      this.discountAmount,
      this.masterproductId,
      this.price,
      this.offerPrice,
      this.offerLabel,
      this.isShowOfferAppliedButton,
      this.isShowAddToCartButton,
      this.isCoach,
      this.isShowAddToCartLabel,
      this.cartId});

  factory OfferData.fromJson(Map<String, dynamic> json) => OfferData(
        id: json["id"]?.toString(),
        title: json["title"]?.toString(),
        description: json["description"]?.toString(),
        discountAmount: json["discount_amount"]?.toString(),
        masterproductId: json["masterproduct_id"]?.toString(),
        price: json["price"]?.toString(),
        offerPrice: json["offer_price"]?.toString(),
        offerLabel: json["offer_label"]?.toString(),
        isShowOfferAppliedButton:
            json["is_show_offer_applied_button"]?.toString(),
        isShowAddToCartButton: json["is_show_add_to_cart_button"]?.toString(),
        isCoach: json["is_coach"]?.toString(),
        isShowAddToCartLabel: json["is_show_add_to_cart_label"] ?? "",
        cartId: json["cart_id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "discount_amount": discountAmount,
        "masterproduct_id": masterproductId,
        "price": price,
        "offer_price": offerPrice,
        "offer_label": offerLabel,
        "is_show_offer_applied_button": isShowOfferAppliedButton,
        "is_show_add_to_cart_button": isShowAddToCartButton,
        "is_show_add_to_cart_label": isShowAddToCartLabel,
        "cart_id": cartId,
      };
}
