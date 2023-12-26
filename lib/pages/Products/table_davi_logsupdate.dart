import 'dart:convert';

import 'package:consugez_inventario/models/logs/update_product_model.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LogMaterialesScreen extends StatelessWidget {
  Future<List<Updateproducts>> futureLogMateriales() async {
    final response =
        await http.get(Uri.parse('${Enviroments.apiurl}/productos/updates'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => new Updateproducts.fromJson(data))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de actualizaciones'),
      ),
      body: FutureBuilder<List<Updateproducts>>(
        future: futureLogMateriales(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(' producto'),
                  ),
                  DataColumn(
                    label: Text('Nombre de usuario'),
                  ),
                  DataColumn(
                    label: Text('Cantidad añadida'),
                  ),
                  DataColumn(
                    label: Text('Fecha de actualización'),
                  ),
                ],
                rows: snapshot.data!
                    .map((logMaterial) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text('${logMaterial.productName}')),
                            DataCell(Text('${logMaterial.userName}')),
                            DataCell(
                                Text(logMaterial.quantityAdded.toString())),
                            DataCell(Text('${logMaterial.updateDate}')),
                          ],
                        ))
                    .toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
