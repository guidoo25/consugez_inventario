import 'package:flutter/material.dart';
import 'package:consugez_inventario/models/obras_model.dart';

class ObrasCard extends StatelessWidget {
  final Obra obra;

  const ObrasCard({required this.obra});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(obra.nombreObra ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha de inicio: ${obra.fechaInicio ?? ''}'),
            Text('Estado de autorización: ${obra.estadoAutorizacion ?? ''}'),
            Text('Ubicación: ${obra.ubicacion ?? ''}'),
            Text('Responsable: ${obra.responsable ?? ''}'),
            Text('RUC Cliente: ${obra.rucliente ?? ''}'),
            Text('Razón Social Comprador: ${obra.razonSocialComprador ?? ''}'),
            Text('Dirección Comprador: ${obra.direccionComprador ?? ''}'),
            Text('Correo: ${obra.correo ?? ''}'),
          ],
        ),
      ),
    );
  }
}
