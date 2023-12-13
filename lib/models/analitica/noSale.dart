// To parse this JSON data, do
//
//     final noSale = noSaleFromJson(jsonString);

import 'dart:convert';

List<NoSale> noSaleFromJson(String str) => List<NoSale>.from(json.decode(str).map((x) => NoSale.fromJson(x)));

String noSaleToJson(List<NoSale> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NoSale {
  final int id;
  final String name;
  final int newStock;

  NoSale({
    required this.id,
    required this.name,
    required this.newStock,
  });

  factory NoSale.fromJson(Map<String, dynamic> json) => NoSale(
    id: json["id"],
    name: json["name"],
    newStock: json["new_stock"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "new_stock": newStock,
  };
}
