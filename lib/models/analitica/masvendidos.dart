// To parse this JSON data, do
//
//     final masvendidos = masvendidosFromJson(jsonString);

import 'dart:convert';

List<Masvendidos> masvendidosFromJson(String str) => List<Masvendidos>.from(json.decode(str).map((x) => Masvendidos.fromJson(x)));

String masvendidosToJson(List<Masvendidos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Masvendidos {
  final int id;
  final String name;
  final int previousStock;
  final int newStock;
  final int quantitySold;

  Masvendidos({
    required this.id,
    required this.name,
    required this.previousStock,
    required this.newStock,
    required this.quantitySold,
  });

  factory Masvendidos.fromJson(Map<String, dynamic> json) => Masvendidos(
    id: json["id"],
    name: json["name"],
    previousStock: json["previous_stock"],
    newStock: json["new_stock"],
    quantitySold: json["quantity_sold"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "previous_stock": previousStock,
    "new_stock": newStock,
    "quantity_sold": quantitySold,
  };
}
