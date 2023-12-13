// To parse this JSON data, do
//
//     final clienteResponse = clienteResponseFromJson(jsonString);

import 'dart:convert';

ClienteResponse clienteResponseFromJson(String str) => ClienteResponse.fromJson(json.decode(str));

String clienteResponseToJson(ClienteResponse data) => json.encode(data.toJson());

class ClienteResponse {
  ClienteResponse({
    required this.clientes,
  });

  List<Cliente> clientes;

  factory ClienteResponse.fromJson(Map<String, dynamic> json) => ClienteResponse(
    clientes: List<Cliente>.from(json["clientes"].map((x) => Cliente.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "clientes": List<dynamic>.from(clientes.map((x) => x.toJson())),
  };
}

class Cliente {
  Cliente({
    required this.id,
    required this.ruc,
    required this.razonSocialComprador,
    required this.dirreccionCliente,
    required this.correo,
  });

  int id;
  String ruc;
  String razonSocialComprador;
  String dirreccionCliente;
  String correo;

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
    id: json["id"],
    ruc: json["ruc"],
    razonSocialComprador: json["razonSocialComprador"],
    dirreccionCliente: json["dirreccionCliente"],
    correo: json["correo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ruc": ruc,
    "razonSocialComprador": razonSocialComprador,
    "dirreccionCliente": dirreccionCliente,
    "correo": correo,
  };
}
