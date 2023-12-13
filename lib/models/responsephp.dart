// To parse this JSON data, do
//
//     final responseGuia = responseGuiaFromJson(jsonString);

import 'dart:convert';

ResponseGuia responseGuiaFromJson(String str) => ResponseGuia.fromJson(json.decode(str));

String responseGuiaToJson(ResponseGuia data) => json.encode(data.toJson());

class ResponseGuia {
  final Return responseGuiaReturn;

  ResponseGuia({
    required this.responseGuiaReturn,
  });

  factory ResponseGuia.fromJson(Map<String, dynamic> json) => ResponseGuia(
    responseGuiaReturn: Return.fromJson(json["return"]),
  );

  Map<String, dynamic> toJson() => {
    "return": responseGuiaReturn.toJson(),
  };
}

class Return {
  final String claveAcceso;
  final dynamic comprobanteId;
  final String estadoComprobante;
  final dynamic mensajes;
  final dynamic numeroAutorizacion;
  final dynamic fechaAutorizacion;

  Return({
    required this.claveAcceso,
    required this.comprobanteId,
    required this.estadoComprobante,
    required this.mensajes,
    required this.numeroAutorizacion,
    required this.fechaAutorizacion,
  });

  factory Return.fromJson(Map<String, dynamic> json) => Return(
    claveAcceso: json["claveAcceso"],
    comprobanteId: json["comprobanteID"],
    estadoComprobante: json["estadoComprobante"],
    mensajes: json["mensajes"],
    numeroAutorizacion: json["numeroAutorizacion"],
    fechaAutorizacion: json["fechaAutorizacion"],
  );

  Map<String, dynamic> toJson() => {
    "claveAcceso": claveAcceso,
    "comprobanteID": comprobanteId,
    "estadoComprobante": estadoComprobante,
    "mensajes": mensajes,
    "numeroAutorizacion": numeroAutorizacion,
    "fechaAutorizacion": fechaAutorizacion,
  };
}
