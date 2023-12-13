// To parse this JSON data, do
//
//     final soapresponse = soapresponseFromJson(jsonString);

import 'dart:convert';

Soapresponse soapresponseFromJson(String str) => Soapresponse.fromJson(json.decode(str));

String soapresponseToJson(Soapresponse data) => json.encode(data.toJson());

class Soapresponse {
  final Return soapresponseReturn;

  Soapresponse({
    required this.soapresponseReturn,
  });

  factory Soapresponse.fromJson(Map<String, dynamic> json) => Soapresponse(
    soapresponseReturn: Return.fromJson(json["return"]),
  );

  Map<String, dynamic> toJson() => {
    "return": soapresponseReturn.toJson(),
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
