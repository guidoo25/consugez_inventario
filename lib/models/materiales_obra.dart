class Materiales {
  final int id;
  final int IDObra;
  final String MaterialUtilizado;
  final String Cantidad;
  final String CodigoMaterial;
  final String FechaUtilizacion;
  final int? cantidadFaltante;
  final double? cantidadSobrante;

  Materiales({
    required this.id,
    required this.IDObra,
    required this.MaterialUtilizado,
    required this.Cantidad,
    required this.CodigoMaterial,
    required this.FechaUtilizacion,
    required this.cantidadFaltante,
    this.cantidadSobrante,
  });

  factory Materiales.fromJson(Map<String, dynamic> json) {
    return Materiales(
      id: json['id'],
      IDObra: json['IDObra'],
      MaterialUtilizado: json['MaterialUtilizado'],
      Cantidad: json['Cantidad'],
      CodigoMaterial: json['CodigoMaterial'],
      FechaUtilizacion: json['FechaUtilizacion'],
      cantidadFaltante: json["CantidadFaltante"],
      cantidadSobrante: json['cantidadSobrante'],
    );
  }
}
