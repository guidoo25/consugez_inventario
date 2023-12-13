import 'dart:convert';

import 'package:consugez_inventario/models/materiales/logs_materiales.dart';
import 'package:consugez_inventario/models/obras_model.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TablasUpdatelogs extends StatelessWidget {
  final Obra idObra;

  const TablasUpdatelogs({
    super.key,
    required this.idObra,
  });
  Future<List<LogMateriales>> getLogs(int idObra) async {
    final response = await http.get(
        Uri.parse('${Enviroments.apiurl}/material-change-log-details/$idObra'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => LogMateriales.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener los materiales');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //un appbar custom
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: Colors.green[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Historial de transacciones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<LogMateriales>>(
            future: getLogs(idObra.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DaviModel<LogMateriales> model = DaviModel<LogMateriales>(
                  rows: snapshot.data!,
                  columns: [
                    DaviColumn(
                      name: 'Material Utilizado',
                      stringValue: (data) => data.materialUtilizado,
                    ),
                    DaviColumn(
                      name: 'Cantidad Aumentada',
                      stringValue: (data) => data.changeAmount.toString(),
                    ),
                    DaviColumn(
                      name: 'Tipo transaccion',
                      stringValue: (data) => data.changeType,
                    ),
                    DaviColumn(
                      name: 'Solicitante de la transaccion',
                      stringValue: (data) => data.solicitante,
                    ),
                    DaviColumn(
                      name: 'Fecha de la transaccion',
                      stringValue: (data) => data.changeDate.toString(),
                    ),
                  ],
                );

                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: DaviTheme(
                    child: Davi<LogMateriales>(model),
                    data: DaviThemeData(
                      row: const RowThemeData(
                        dividerThickness: 4,
                        dividerColor: Colors.black12,
                      ),
                      header: HeaderThemeData(
                        color: Colors.green[50],
                        bottomBorderHeight: 4,
                        bottomBorderColor: Colors.black45,
                      ),
                      headerCell: HeaderCellThemeData(
                        height: 40,
                        alignment: Alignment.center,
                        textStyle: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        resizeAreaWidth: 10,
                        resizeAreaHoverColor: Colors.blue.withOpacity(.3),
                        sortIconColors: SortIconColors.all(Colors.blueAccent),
                        expandableName: false,
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ],
    );
  }
}
