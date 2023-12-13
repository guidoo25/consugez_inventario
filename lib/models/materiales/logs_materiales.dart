// To parse this JSON data, do
//
//     final logMateriales = logMaterialesFromJson(jsonString);

import 'dart:convert';

List<LogMateriales> logMaterialesFromJson(String str) =>
    List<LogMateriales>.from(
        json.decode(str).map((x) => LogMateriales.fromJson(x)));

String logMaterialesToJson(List<LogMateriales> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LogMateriales {
  final int id;
  final DateTime changeDate;
  final int changeAmount;
  final String changeType;
  final int materialId;
  final int obraId;
  final String? solicitante;
  final String materialUtilizado;

  LogMateriales({
    required this.id,
    required this.changeDate,
    required this.changeAmount,
    required this.changeType,
    required this.materialId,
    required this.obraId,
    this.solicitante,
    required this.materialUtilizado,
  });

  factory LogMateriales.fromJson(Map<String, dynamic> json) => LogMateriales(
        id: json["ID"],
        changeDate: DateTime.parse(json["ChangeDate"]),
        changeAmount: json["ChangeAmount"],
        changeType: json["ChangeType"],
        materialId: json["MaterialID"],
        obraId: json["ObraID"],
        solicitante: json["Solicitante"],
        materialUtilizado: json["MaterialUtilizado"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "ChangeDate": changeDate.toIso8601String(),
        "ChangeAmount": changeAmount,
        "ChangeType": changeType,
        "MaterialID": materialId,
        "ObraID": obraId,
        "Solicitante": solicitante,
        "MaterialUtilizado": materialUtilizado,
      };
}
