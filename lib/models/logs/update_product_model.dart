// To parse this JSON data, do
//
//     final updateproducts = updateproductsFromJson(jsonString);

import 'dart:convert';

List<Updateproducts> updateproductsFromJson(String str) =>
    List<Updateproducts>.from(
        json.decode(str).map((x) => Updateproducts.fromJson(x)));

String updateproductsToJson(List<Updateproducts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Updateproducts {
  final int updateId;
  final String productName;
  final String userName;
  final int quantityAdded;
  final DateTime updateDate;

  Updateproducts({
    required this.updateId,
    required this.productName,
    required this.userName,
    required this.quantityAdded,
    required this.updateDate,
  });

  factory Updateproducts.fromJson(Map<String, dynamic> json) => Updateproducts(
        updateId: json["update_id"],
        productName: json["product_name"],
        userName: json["user_name"],
        quantityAdded: json["quantity_added"],
        updateDate: DateTime.parse(json["update_date"]),
      );

  Map<String, dynamic> toJson() => {
        "update_id": updateId,
        "product_name": productName,
        "user_name": userName,
        "quantity_added": quantityAdded,
        "update_date": updateDate.toIso8601String(),
      };
}
