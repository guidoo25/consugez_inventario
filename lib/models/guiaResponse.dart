// To parse this JSON data, do
//
//     final guiaResponse = guiaResponseFromJson(jsonString);

import 'dart:convert';

List<GuiaResponse> guiaResponseFromJson(String str) => List<GuiaResponse>.from(json.decode(str).map((x) => GuiaResponse.fromJson(x)));

String guiaResponseToJson(List<GuiaResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GuiaResponse {
  final int id;
  final String nombreCliente;
  final String direccionCliente;
  final dynamic guiaValue;
  final DetalleProducto detalleProducto;

  GuiaResponse({
    required this.id,
    required this.nombreCliente,
    required this.direccionCliente,
    required this.guiaValue,
    required this.detalleProducto,
  });

  factory GuiaResponse.fromJson(Map<String, dynamic> json) => GuiaResponse(
    id: json["id"],
    nombreCliente: json["nombre_cliente"],
    direccionCliente: json["direccion_cliente"],
    guiaValue: json["guia_value"],
    detalleProducto: DetalleProducto.fromJson(json["detalle_producto"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre_cliente": nombreCliente,
    "direccion_cliente": direccionCliente,
    "guia_value": guiaValue,
    "detalle_producto": detalleProducto.toJson(),
  };
}

class DetalleProducto {
  final List<Producto> productos;

  DetalleProducto({
    required this.productos,
  });

  factory DetalleProducto.fromJson(Map<String, dynamic> json) => DetalleProducto(
    productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
  };
}

class Producto {
  final String codigo;
  final String nombre;
  final int cantidad;

  Producto({
    required this.codigo,
    required this.nombre,
    required this.cantidad,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
    codigo: json["codigo"],
    nombre: json["nombre"],
    cantidad: json["cantidad"],
  );

  Map<String, dynamic> toJson() => {
    "codigo": codigo,
    "nombre": nombre,
    "cantidad": cantidad,
  };
}

class Guia {
  final String placa;
  final String codigo;
  final int cantidad;
  final String fechaFin;
  final String ptoEmision;
  final String secuencial;
  final String descripcion;
  final String idDestinatario;
  final String motivoTraslado;
  final String correoComprador;
  final String dirDestinatario;
  final String establecimiento;
  final String direccionPartida;
  final String rucTransportista;
  final String fechaIniTransporte;
  final String razonSocialDestinatario;
  final String razonSocialTransportista;

  Guia({
    required this.placa,
    required this.codigo,
    required this.cantidad,
    required this.fechaFin,
    required this.ptoEmision,
    required this.secuencial,
    required this.descripcion,
    required this.idDestinatario,
    required this.motivoTraslado,
    required this.correoComprador,
    required this.dirDestinatario,
    required this.establecimiento,
    required this.direccionPartida,
    required this.rucTransportista,
    required this.fechaIniTransporte,
    required this.razonSocialDestinatario,
    required this.razonSocialTransportista,
  });

  factory Guia.fromJson(Map<String, dynamic> json) => Guia(
    placa: json["placa"],
    codigo: json["codigo"],
    cantidad: json["cantidad"],
    fechaFin: json["fechaFin"],
    ptoEmision: json["ptoEmision"],
    secuencial: json["secuencial"],
    descripcion: json["descripcion"],
    idDestinatario: json["idDestinatario"],
    motivoTraslado: json["motivoTraslado"],
    correoComprador: json["correoComprador"],
    dirDestinatario: json["dirDestinatario"],
    establecimiento: json["establecimiento"],
    direccionPartida: json["direccionPartida"],
    rucTransportista: json["rucTransportista"],
    fechaIniTransporte: json["fechaIniTransporte"],
    razonSocialDestinatario: json["razonSocialDestinatario"],
    razonSocialTransportista: json["razonSocialTransportista"],
  );

  Map<String, dynamic> toJson() => {
    "placa": placa,
    "codigo": codigo,
    "cantidad": cantidad,
    "fechaFin": fechaFin,
    "ptoEmision": ptoEmision,
    "secuencial": secuencial,
    "descripcion": descripcion,
    "idDestinatario": idDestinatario,
    "motivoTraslado": motivoTraslado,
    "correoComprador": correoComprador,
    "dirDestinatario": dirDestinatario,
    "establecimiento": establecimiento,
    "direccionPartida": direccionPartida,
    "rucTransportista": rucTransportista,
    "fechaIniTransporte": fechaIniTransporte,
    "razonSocialDestinatario": razonSocialDestinatario,
    "razonSocialTransportista": razonSocialTransportista,
  };
}

class GuiaValueClass {
  final List<Guia> guia;

  GuiaValueClass({
    required this.guia,
  });

  factory GuiaValueClass.fromJson(Map<String, dynamic> json) => GuiaValueClass(
    guia: List<Guia>.from(json["guia"].map((x) => Guia.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "guia": List<dynamic>.from(guia.map((x) => x.toJson())),
  };
}
