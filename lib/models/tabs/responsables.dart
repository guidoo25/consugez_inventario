// To parse this JSON data, do
//
//     final responsablesResponse = responsablesResponseFromJson(jsonString);

import 'dart:convert';

List<ResponsablesResponse> responsablesResponseFromJson(String str) =>
    List<ResponsablesResponse>.from(
        json.decode(str).map((x) => ResponsablesResponse.fromJson(x)));

String responsablesResponseToJson(List<ResponsablesResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResponsablesResponse {
  final int idEncargado;
  final String nombre;
  final String email;
  final String telefono;

  ResponsablesResponse({
    required this.idEncargado,
    required this.nombre,
    required this.email,
    required this.telefono,
  });

  factory ResponsablesResponse.fromJson(Map<String, dynamic> json) =>
      ResponsablesResponse(
        idEncargado: json["id_encargado"],
        nombre: json["nombre"],
        email: json["email"],
        telefono: json["telefono"],
      );

  Map<String, dynamic> toJson() => {
        "id_encargado": idEncargado,
        "nombre": nombre,
        "email": email,
        "telefono": telefono,
      };
}
