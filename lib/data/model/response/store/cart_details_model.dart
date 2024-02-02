// To parse this JSON data, do
//
//     final cartDetailsModel = cartDetailsModelFromJson(jsonString);

import 'dart:convert';

CartDetailsModel cartDetailsModelFromJson(String str) =>
    CartDetailsModel.fromJson(json.decode(str));

String cartDetailsModelToJson(CartDetailsModel data) =>
    json.encode(data.toJson());

class CartDetailsModel {
  int? status;
  CartDetailData? data;
  String? message;

  CartDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory CartDetailsModel.fromJson(Map<String, dynamic> json) =>
      CartDetailsModel(
        status: json["status"],
        data:
            json["data"] == null ? null : CartDetailData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class CartDetailData {
  List<MainProductList>? mainProductList;
  String? totalToPaid;
  String? totalAmount;
  String? isShowWalletAmount;
  double? walletAmount;
  String? creditAmount;
  String? promocode;

  int? isPrecardOffer;
  int? isPostcardOffer;

  CartDetailData({
    this.mainProductList,
    this.totalToPaid,
    this.totalAmount,
    this.isShowWalletAmount,
    this.walletAmount,
    this.creditAmount,
    this.promocode,
    this.isPrecardOffer,
    this.isPostcardOffer,
  });

  factory CartDetailData.fromJson(Map<String, dynamic> json) => CartDetailData(
        mainProductList: json["main_product_list"] == null
            ? []
            : List<MainProductList>.from(json["main_product_list"]!
                .map((x) => MainProductList.fromJson(x))),
        totalToPaid: json["total_to_paid"]?.toString(),
        isShowWalletAmount: json["is_show_wallet_amount"],
        walletAmount:
            json["wallet_amount"] != null && json["wallet_amount"] != ""
                ? double.parse(json["wallet_amount"].toString())
                : 0.0,
        creditAmount: json["credit_amount"]?.toString(),
        promocode: json["promocode"],
        totalAmount: json["total_amount"]?.toString(),
        isPrecardOffer: json["is_precard_offer"] ?? 0,
        isPostcardOffer: json["is_postcard_offer"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "main_product_list": mainProductList == null
            ? []
            : List<dynamic>.from(mainProductList!.map((x) => x.toJson())),
        "total_to_paid": totalToPaid,
        "is_show_wallet_amount": isShowWalletAmount,
        "wallet_amount": walletAmount,
        "credit_amount": creditAmount,
      };
}

class MainProductList {
  String? title;
  List<ProductList>? productList;
  String? totalToPaid;

  MainProductList({
    this.title,
    this.productList,
    this.totalToPaid,
  });

  factory MainProductList.fromJson(Map<String, dynamic> json) =>
      MainProductList(
        title: json["title"],
        productList: json["product_list"] == null
            ? []
            : List<ProductList>.from(
                json["product_list"]!.map((x) => ProductList.fromJson(x))),
        totalToPaid: json["total_to_paid"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "product_list": productList == null
            ? []
            : List<dynamic>.from(productList!.map((x) => x.toJson())),
        "total_to_paid": totalToPaid,
      };
}

class ProductList {
  String? productName;
  String? productId;
  String? price;
  String? text;
  String? isDiscount;
  List<DiscountList>? discountList;
  List<AssessmentCoachingHour>? assessmentCoachingHours;
  String? isDeleteShow;
  String? offerType;
  int? cartId;

  ProductList({
    this.productName,
    this.productId,
    this.discountList,
    this.price,
    this.text,
    this.isDiscount,
    this.assessmentCoachingHours,
    this.isDeleteShow,
    this.offerType,
    this.cartId,
  });

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        productName: json["product_name"],
        productId: json["product_id"]?.toString(),
        price: json["price"]?.toString(),
        text: json["text"],
        isDiscount: json["is_discount"]?.toString(),
        discountList: json["discountList"] == null
            ? []
            : List<DiscountList>.from(
                json["discountList"]!.map((x) => DiscountList.fromJson(x))),
        assessmentCoachingHours: json["assessmentCoachingHours"] == null
            ? []
            : List<AssessmentCoachingHour>.from(json["assessmentCoachingHours"]!
                .map((x) => AssessmentCoachingHour.fromJson(x))),
        isDeleteShow: json["is_delete_show"]?.toString(),
        offerType: json["is_delete_label"]?.toString(),
        cartId: json["cart_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "product_id": productId,
        "price": price,
        "text": text,
      };
}

class DiscountList {
  int? productId;
  String? text;
  String? productName;
  int? isDiscount;
  String? price;
  String? dicountPrice;
  String? isDeleteDiscLabel;
  String? isDeleteDiscShow;

  DiscountList(
      {this.productId,
      this.text,
      this.productName,
      this.isDiscount,
      this.price,
      this.isDeleteDiscShow,
      this.isDeleteDiscLabel,
      this.dicountPrice});

  factory DiscountList.fromJson(Map<String, dynamic> json) => DiscountList(
        productId: json["product_id"],
        text: json["text"]?.toString(),
        productName: json["product_name"]?.toString(),
        isDiscount: json["is_discount"],
        price: json["price"]?.toString(),
        isDeleteDiscLabel: json["is_delete_disc_label"]?.toString() ?? "",
        isDeleteDiscShow: json["is_delete_disc_show"]?.toString() ?? "",
        dicountPrice: json["discount_value"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "text": text,
        "product_name": productName,
        "is_discount": isDiscount,
        "price": price,
      };
}

class AssessmentCoachingHour {
  String? productName;
  String? productId;
  String? text;
  String? price;

  AssessmentCoachingHour({
    this.productName,
    this.productId,
    this.text,
    this.price,
  });

  factory AssessmentCoachingHour.fromJson(Map<String, dynamic> json) =>
      AssessmentCoachingHour(
        productName: json["product_name"]?.toString(),
        productId: json["product_id"]?.toString(),
        text: json["text"]?.toString(),
        price: json["price"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "product_id": productId,
        "text": text,
        "price": price,
      };
}
