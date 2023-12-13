import 'dart:convert';

import 'package:consugez_inventario/models/materiales_obra.dart';
import 'package:consugez_inventario/models/obras_model.dart';
import 'package:consugez_inventario/pages/mats_updates/table_logs_update_obras.dart';
import 'package:consugez_inventario/theme/enviroments.dart';
import 'package:consugez_inventario/widgets/Guia/emisor.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TablasObrasAumento extends StatefulWidget {
  final Obra idObra;
  final String role;
  final String solicitante;

  const TablasObrasAumento(
      {Key? key,
      required this.idObra,
      required this.role,
      required this.solicitante})
      : super(key: key);

  @override
  _TablasObrasAumentoState createState() => _TablasObrasAumentoState();
}

class _TablasObrasAumentoState extends State<TablasObrasAumento> {
  Future<List<Materiales>> getMateriales(int idObra) async {
    final response = await http
        .get(Uri.parse('${Enviroments.apiurl}/obras/$idObra/materiales'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['materiales'];

      materialesss = jsonResponse
          .map((item) => Materiales.fromJson(item))
          .toList()
          .cast<Materiales>();
      return jsonResponse.map((item) => Materiales.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener los materiales');
    }
  }

  List<Materiales> materialesss = [];

  Future<void> updateMaterialfaltante(int idObra, int idMaterial,
      String cantidadFaltante, String Solicitante) async {
    final url =
        Uri.parse('${Enviroments.apiurl}/obras/$idObra/materiales/$idMaterial');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cantidadFaltante': double.parse(cantidadFaltante).toString(),
        'solicitante': Solicitante,
      }),
    );
    if (response.statusCode == 200) {
      print('Cantidad faltante y sobrante actualizadas exitosamente');
    } else {
      throw Exception('Error al actualizar la cantidad faltante y sobrante');
    }
  }

  Future<void> aumentarCantidad(int idObra, int idMaterial,
      int cantidadFaltante, String solicitante) async {
    final response = await http.put(
      Uri.parse(
          '${Enviroments.apiurl}/obras/$idObra/$idMaterial/aumentar'), // Reemplaza 'your-api-url' con la URL de tu API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'cantidadFaltante': cantidadFaltante,
        'Solicitante': solicitante,
      }),
    );

    if (response.statusCode == 200) {
      print('Cantidad actualizada y aumento registrado exitosamente');
    } else {
      throw Exception('Error al aumentar la cantidad: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    String values = '1';
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (widget.role == '777' ||
              widget.idObra.estadoAutorizacion == 'AGUI')
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FacturaWidget(
                        materialess: materialesss,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.emoji_transportation),
                label: Text('Guia de Remision'))
        ],
        title: Text(
            'Asignar Aumento a Obra : ${widget.idObra.nombreObra}, Id: ${widget.idObra.id}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Materiales>>(
              future: getMateriales(widget.idObra.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  DaviModel<Materiales> model = DaviModel<Materiales>(
                    rows: snapshot.data!,
                    columns: [
                      DaviColumn(
                        name: 'Material Asignado',
                        stringValue: (data) => data.MaterialUtilizado,
                      ),
                      DaviColumn(
                        name: 'Cantidad',
                        stringValue: (data) => data.Cantidad.toString(),
                      ),
                      DaviColumn(
                        name: 'Codigo Material',
                        stringValue: (data) => data.CodigoMaterial,
                      ),
                      DaviColumn(
                        name: 'Fecha de Asignacion',
                        stringValue: (data) => data.FechaUtilizacion,
                      ),
                      DaviColumn(
                        name: 'Cantidad Faltante',
                        stringValue: (data) => data.cantidadFaltante != null
                            ? data.cantidadFaltante.toString()
                            : '0',
                        cellBuilder: (context, rowData) {
                          final cantidadFaltante =
                              rowData.data.cantidadFaltante ?? 0;
                          final color = cantidadFaltante > 0
                              ? Color.fromARGB(255, 247, 255, 201)
                              : Colors.transparent;
                          return Container(
                            color: color,
                            child: Text(
                              cantidadFaltante.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                      if (widget.role == '777')
                        DaviColumn(
                          name: 'Acciones',
                          cellBuilder: (context, rowData) {
                            return IconButton(
                                icon: const Icon(Icons.check_box),
                                onPressed: () {
                                  aumentarCantidad(
                                      widget.idObra.id,
                                      rowData.data.id,
                                      rowData.data.cantidadFaltante!,
                                      widget.solicitante);
                                  setState(() {});
                                });
                          },
                        ),
                      if (widget.role == '555' || widget.role == '777')
                        DaviColumn(
                          name: 'Asignar Aumento',
                          cellBuilder: (context, rowData) {
                            return IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Aumentar Cantidad'),
                                      content: TextFormField(
                                        // initialValue y onFieldSubmitted dependen de tu implementación
                                        initialValue: '1',
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          //guardar el valor
                                          values = value;
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('Aceptar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();

                                            updateMaterialfaltante(
                                                widget.idObra.id,
                                                rowData.data.id,
                                                values,
                                                widget.solicitante);
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        )
                    ],
                  );

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: DaviTheme(
                      child: Davi<Materiales>(model),
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
          if (widget.role == '777')
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Row(
                children: [
                  Expanded(
                    child: TablasUpdatelogs(idObra: widget.idObra),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
