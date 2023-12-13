// To parse this JSON data, do
//
//     final ptoemisionResponce = ptoemisionResponceFromJson(jsonString);

import 'dart:convert';

PtoemisionResponce ptoemisionResponceFromJson(String str) => PtoemisionResponce.fromJson(json.decode(str));

String ptoemisionResponceToJson(PtoemisionResponce data) => json.encode(data.toJson());

class PtoemisionResponce {
  PtoemisionResponce({
    required this.facturaUltimo,
    required this.codigo,
  });

  final int facturaUltimo;
  final String codigo;


  factory PtoemisionResponce.fromJson(Map<String, dynamic> json) => PtoemisionResponce(
    facturaUltimo: json["facturaUltimo"],
    codigo: json["codigo"],

  );

  Map<String, dynamic> toJson() => {
    "facturaUltimo": facturaUltimo,
    "codigo": codigo,

  };
}
