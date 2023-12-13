// To parse this JSON data, do
//
//     final pocostock = pocostockFromJson(jsonString);

import 'dart:convert';

List<Pocostock> pocostockFromJson(String str) => List<Pocostock>.from(json.decode(str).map((x) => Pocostock.fromJson(x)));

String pocostockToJson(List<Pocostock> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pocostock {
  final int id;
  final String name;
  final int newStock;

  Pocostock({
    required this.id,
    required this.name,
    required this.newStock,
  });

  factory Pocostock.fromJson(Map<String, dynamic> json) => Pocostock(
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
