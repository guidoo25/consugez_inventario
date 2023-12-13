// To parse this JSON data, do
//
//     final obrasReponse = obrasReponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ObrasReponse obrasReponseFromJson(String str) =>
    ObrasReponse.fromJson(json.decode(str));

String obrasReponseToJson(ObrasReponse data) => json.encode(data.toJson());

class ObrasReponse {
  final List<Obra> obras;

  ObrasReponse({
    required this.obras,
  });

  factory ObrasReponse.fromJson(Map<String, dynamic> json) => ObrasReponse(
        obras: List<Obra>.from(json["obras"].map((x) => Obra.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "obras": List<dynamic>.from(obras.map((x) => x.toJson())),
      };
}

class Obra {
  final int id;
  final String nombreObra;
  final String fechaInicio;
  final String estadoAutorizacion;
  final String ubicacion;
  final String responsable;
  final String rucliente;
  final String razonSocialComprador;
  final String direccionComprador;
  final String correo;

  Obra({
    required this.id,
    required this.nombreObra,
    required this.fechaInicio,
    required this.estadoAutorizacion,
    required this.ubicacion,
    required this.responsable,
    required this.rucliente,
    required this.razonSocialComprador,
    required this.direccionComprador,
    required this.correo,
  });

  factory Obra.fromJson(Map<String, dynamic> json) => Obra(
        id: json["id"],
        nombreObra: json["NombreObra"],
        fechaInicio: json["FechaInicio"],
        estadoAutorizacion: json["EstadoAutorizacion"],
        ubicacion: json["Ubicacion"],
        responsable: json["Responsable"],
        rucliente: json["rucliente"],
        razonSocialComprador: json["razonSocialComprador"],
        direccionComprador: json["direccionComprador"],
        correo: json["correo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "NombreObra": nombreObra,
        "FechaInicio": fechaInicio,
        "EstadoAutorizacion": estadoAutorizacion,
        "Ubicacion": ubicacion,
        "Responsable": responsable,
        "rucliente": rucliente,
        "razonSocialComprador": razonSocialComprador,
        "direccionComprador": direccionComprador,
        "correo": correo,
      };
}
