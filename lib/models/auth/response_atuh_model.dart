// To parse this JSON data, do
//
//     final authReponse = authReponseFromJson(jsonString);

import 'dart:convert';

AuthReponse authReponseFromJson(String str) =>
    AuthReponse.fromJson(json.decode(str));

String authReponseToJson(AuthReponse data) => json.encode(data.toJson());

class AuthReponse {
  final String message;
  final String nombre;
  final int userId;
  final String token;
  final String rol;

  AuthReponse({
    required this.message,
    required this.nombre,
    required this.userId,
    required this.token,
    required this.rol,
  });

  factory AuthReponse.fromJson(Map<String, dynamic> json) => AuthReponse(
        message: json["message"],
        nombre: json["nombre"],
        userId: json["userId"],
        token: json["token"],
        rol: json["rol"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "nombre": nombre,
        "userId": userId,
        "token": token,
        "rol": rol,
      };
}
