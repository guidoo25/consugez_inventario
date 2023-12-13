// To parse this JSON data, do
//
//     final updateresponse = updateresponseFromJson(jsonString);

import 'dart:convert';

Updateresponse updateresponseFromJson(String str) => Updateresponse.fromJson(json.decode(str));

String updateresponseToJson(Updateresponse data) => json.encode(data.toJson());

class Updateresponse {
  final List<StockUpdatesLog> stockUpdatesLog;

  Updateresponse({
    required this.stockUpdatesLog,
  });

  factory Updateresponse.fromJson(Map<String, dynamic> json) => Updateresponse(
    stockUpdatesLog: List<StockUpdatesLog>.from(json["stockUpdatesLog"].map((x) => StockUpdatesLog.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "stockUpdatesLog": List<dynamic>.from(stockUpdatesLog.map((x) => x.toJson())),
  };
}

class StockUpdatesLog {
  final int id;
  final int productId;
  final String productName;
  final int previousStock;
  final int newStock;
  final DateTime updateTime;
  final int clienteId;
  final String clienteName;

  StockUpdatesLog({
    required this.id,
    required this.productId,
    required this.productName,
    required this.previousStock,
    required this.newStock,
    required this.updateTime,
    required this.clienteId,
    required this.clienteName,
  });

  factory StockUpdatesLog.fromJson(Map<String, dynamic> json) => StockUpdatesLog(
    id: json["id"],
    productId: json["product_id"],
    productName: json["product_name"],
    previousStock: json["previous_stock"],
    newStock: json["new_stock"],
    updateTime: DateTime.parse(json["update_time"]),
    clienteId: json["cliente_id"],
    clienteName: json["cliente_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "product_name": productName,
    "previous_stock": previousStock,
    "new_stock": newStock,
    "update_time": updateTime.toIso8601String(),
    "cliente_id": clienteId,
    "cliente_name": clienteName,
  };
}
